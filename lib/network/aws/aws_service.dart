import 'dart:io';

class AWSS3Service {
  final String bucketName = 'plrs-assignments';
  final String folderName = 'tasks/<Candidate Name>';

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
  }
}
