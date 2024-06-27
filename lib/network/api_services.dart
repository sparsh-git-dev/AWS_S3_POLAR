import 'dart:convert';
import 'dart:developer';

import 'package:aws_s3_polar/utility/dialog_service/dialog_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const cloudName = "dnhopswdo";
  static const unsigned = "'mxip6anx'";

  /// This Dart function fetches data from a given URL using HTTP GET request and returns the response
  /// body if the status code is 200, otherwise logs or throws an exception.
  ///
  /// Args:
  ///   url (String): The `fetchData` function you provided is an asynchronous function that fetches data
  /// from a URL using the `http` package. The `url` parameter is the URL from which you want to fetch
  /// data.
  ///
  /// Returns:
  ///   The `fetchData` function returns a `Future<String?>`. If the HTTP response status code is 200, it
  /// returns the response body as a `String`. If an exception is caught during the HTTP request, it
  /// throws an `Exception` with a specific message. If any other type of exception occurs, it logs an
  /// error message and returns `null`.
  static Future<String?> fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      }
    } on Exception catch (e) {
      throw Exception('Failed - $url - error - $e');
    } catch (e) {
      log("Failed - $url -  error - $e");
    }
    return null;
  }

  /// This Dart function saves data to a specified URL with optional body content and loader display.
  ///
  /// Args:
  ///   url (String): The `url` parameter is a required `String` that represents the endpoint where the
  /// data will be sent for saving.
  ///   body (Object): The `body` parameter in the `saveData` function is of type `Object?`, which means
  /// it can accept any type of object or `null`. This parameter is used to provide the data that will be
  /// sent in the HTTP POST request to the specified `url`. The `body` is
  ///   showLoader (bool): The `showLoader` parameter in the `saveData` function is a boolean parameter
  /// that determines whether a loader should be displayed while the data is being saved. If `showLoader`
  /// is set to `true`, a loader will be displayed using the `DialogService().showLoader()` method before
  /// making. Defaults to false
  ///
  /// Returns:
  ///   The `saveData` function returns a `Future<bool>`.
  static Future<bool> saveData(
      {required String url, Object? body, bool showLoader = false}) async {
    showLoader ? DialogService().showLoader() : null;

    try {
      final response = await http.post(Uri.parse(url), body: json.encode(body));
      if (response.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      throw Exception('Failed - $url - error - $e');
    } catch (e) {
      log("Failed - $url -  error - $e");
    } finally {
      showLoader ? DialogService().closeLoader() : null;
    }
    return true;
  }

  /// The function `uploadCloudinary` uploads a file to Cloudinary and returns the URL of the uploaded
  /// file, with an optional loader display.
  ///
  /// Args:
  ///   filePath (String): The `filePath` parameter in the `uploadCloudinary` function is the path to
  /// the file that you want to upload to Cloudinary. It specifies the location of the file on the
  /// device's storage that you want to send to the Cloudinary server for uploading.
  ///   showLoader (bool): The `showLoader` parameter in the `uploadCloudinary` function is a boolean
  /// parameter that determines whether a loader should be displayed while the file is being uploaded to
  /// Cloudinary. If `showLoader` is set to `true`, a loader will be displayed using the
  /// `DialogService().showLoader. Defaults to false
  ///
  /// Returns:
  ///   The `uploadCloudinary` function returns a `Future<String?>`. This future will either contain the
  /// URL of the uploaded file if the upload was successful and the response status code is 200, or it
  /// will be null if there was an error during the upload process.
  static Future<String?> uploadCloudinary(String filePath,
      {bool showLoader = false}) async {
    showLoader ? DialogService().showLoader() : null;
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/upload');
    final request = http.MultipartRequest('POST', url);
    request.fields['upload_preset'] = unsigned;
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        final url = jsonMap['url'];
        return url;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      showLoader ? DialogService().closeLoader() : null;
    }
    return null;
  }
}
