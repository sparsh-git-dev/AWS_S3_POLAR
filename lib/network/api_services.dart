import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aws_s3_polar/utility/dialog_service/dialog_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
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

  static Future<bool> saveData(
      {required String url, Object? body, bool showLoader = false}) async {
    // showLoader ? DialogService().showLoader() : null;
    print(body.toString());

    body = {
      "data": [
        {
          "Consumer Number": "12345",
          "Service Options": ["Option 1", "Option 3"],
          "Satisfaction Level": "Satisfied",
          "Preferred Contact Method": "Email",
          "Profile Picture": "path/to/profile_picture.jpg"
        }
      ]
    };
    // return false;
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
      // showLoader ? DialogService().showLoader() : null;
    }
    return true;
  }

  // Future<dynamic> uploadMultipleFilesToS3(
  //     List<File> docxFiles, String url, String fieldName) async {
  //   final uri = Uri.parse(url);
  //   http.MultipartRequest request = http.MultipartRequest('POST', uri);
  //   final headers = await createAuthorizationHeader();
  //   request.headers.addAll(headers);
  //   List<http.MultipartFile> newDocxList = <http.MultipartFile>[];
  //   for (final File docxFile in docxFiles) {
  //     http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
  //         fieldName, docxFile.path,
  //         filename: path.basename(docxFile.path));
  //     newDocxList.add(multipartFile);
  //   }
  //   request.files.addAll(newDocxList);
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     return response;
  //   } else if (response.statusCode == 500) {
  //   } else {}
  // }

  Future<bool> uploadToS3({
    required String uploadUrl,
    required Map<String, String> data,
    required List<int> fileAsBinary,
    required String filename,
  }) async {
    var multiPartFile =
        http.MultipartFile.fromBytes('file', fileAsBinary, filename: filename);
    var uri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(data)
      ..files.add(multiPartFile);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 204) {
      print('Uploaded!');
      return true;
    }
    return false;
  }
}
