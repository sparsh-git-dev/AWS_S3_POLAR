import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AWSS3Service {
//
//s3://plrs-assignments-sparsh/tasks/
//https://plrs-assignments-sparsh.s3.amazonaws.com/tasks/

  Future<void> uploadImage(File image) async {
    // final credentials = AwsClientCredentials(accessKey: 'YOUR_ACCESS_KEY', secretKey: 'YOUR_SECRET_KEY');
    // final s3 = S3(region: 'YOUR_REGION', credentials: credentials);

    // try {
    //   await s3.putObject(
    //     bucket: bucketName,
    //     key: '$folderName/${bucketName(image.path)}',
    //     body: image.openRead(),
    //   );
    // } catch (e) {
    //   print('Error uploading image: $e');
    // }
    //   {url: 'https://mytestbucket.s3.amazonaws.com/',
    // fields: {
    //   "key": "inputdata/user1/myDataFile.xlsx",
    //   "AWSAccessKeyId": "ASIAABCXXXXXXXXXXXX",
    //   "x-amz-security-token": "abcxyzloremipsum",
    //   "policy": "abcxyzloremipsum",
    //   "signature": "abcxyzloremipsum",
    // },}
  }
  static Future<bool> uploadToS3({
    required XFile fileAsBinary,
    required String filename,
    required String url,
  }) async {
    final Map<String, String> data = {
      "key": fileAsBinary.path.split("/").last,
      "acl": 'public-read',
    };
    try {
      var multiPartFile = http.MultipartFile.fromPath('file', fileAsBinary.path,
          filename: filename);
      var uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri)
        ..fields.addAll(data)
        ..files.add(await multiPartFile);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 204) {
        print('Uploaded!');
        return true;
      }
    } catch (e) {
      log("http.MultipartFile - URL: $url --- $e ");
    }
    return false;
  }
}
