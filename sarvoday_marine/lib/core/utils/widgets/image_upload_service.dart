import 'dart:io';
import 'package:dio/dio.dart';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sarvoday_marine/core/utils/widgets/blacblize_helper.dart';

class S3Service {
  final Dio dio = Dio();

  final String accessKey = '0055e6ecf8dfc2b0000000001';
  final String secretKey = 'K005GcWKn1r7dlfgEVDZA5x5suG2Tj8';
  final String bucketName = 'sarvoday-marine-bucket';
  final String region = 'us-east-005';
  final String endpoint = 'https://s3.us-east-005.backblazeb2.com';

  Future<void> uploadMultipleImages(
      List<String> filePaths, List<String> s3Paths) async {
    if (filePaths.length != s3Paths.length) {
      print('File paths and S3 paths must have the same length.');
      return;
    }

    for (int i = 0; i < filePaths.length; i++) {
      String filePath = filePaths[i];
      String s3Path = s3Paths[i];

      try {
        await uploadFile(filePath, s3Path);
        print('Successfully uploaded $filePath to $s3Path.');
      } catch (e) {
        print('Error uploading $filePath to $s3Path: $e');
      }
    }
  }

  // Helper function to upload a single file
  Future<void> uploadFile(String filePath, String s3Path) async {
    final file = File(filePath);
    final fileName = basename(filePath);
    final url = '$endpoint/$bucketName/$s3Path/$fileName';

    final now = DateTime.now().toUtc();
    final dateFormat = DateFormat('yyyyMMddTHHmmssZ');
    final timestamp = '${dateFormat.format(now)}Z';
    final dateFormat2 = DateFormat('yyyyMMdd'); // Format for 'yearMonthDay'
    final requestDate = dateFormat2.format(now);

    // Prepare headers
    final headers = {
      'Content-Type': 'image/jpeg',
      'x-amz-date': timestamp,
      'date': timestamp,
    };

    // Generate canonical request and string to sign
    final payload = await file.readAsBytes();
    final canonicalRequest = getCanonicalRequest(
        'PUT', '/$bucketName/$s3Path/$fileName', headers, payload);
    final stringToSign =
        getStringToSign(canonicalRequest, requestDate, region, 's3');
    final signature =
        getSignature(stringToSign, secretKey, requestDate, region, 's3');

    // Create authorization header
    final authorizationHeader =
        'AWS4-HMAC-SHA256 Credential=$accessKey/$requestDate/$region/s3/aws4_request, '
        'SignedHeaders=${headers.keys.map((k) => k.toLowerCase()).join(';')}, '
        'Signature=$signature';
    try {
      // FormData formData = FormData.fromMap({
      //   'file': await MultipartFile.fromFile(filePath, filename: fileName),
      // });
      final file = File(filePath);

      // Read file as binary data
      final fileBytes = await file.readAsBytes();

      final response = await dio.put(
        url,
        data: fileBytes,
        options: Options(
          headers: {
            ...headers,
            'Authorization': authorizationHeader,
            'Content-Length': fileBytes.length.toString(),
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Upload successful: $fileName to $s3Path.');
      } else {
        print('Failed to upload $fileName: ${response.statusMessage}');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.data}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}

// Future<void> uploadMultipleImages(List<String> filePaths, String orderId,
//     String serviceName, String containerName, List<String> fileName) async {
//   for (int i = 0; i < filePaths.length; i++) {
//     String filePath = filePaths[i];
//     // String s3Path = s3Paths[i];
//
//     // try {
//     //   print('Successfully uploaded $filePath to $s3Path.');
//     // } catch (e) {
//     //   print('Error uploading $filePath to $s3Path: $e');
//     // }
//   }
// }

Future<void> uploadMultipleFiles(
    List<String> filePaths, List<String> preSignedUrls) async {
  Dio dio = Dio();
  if (filePaths.length != preSignedUrls.length) {
    print('File paths and S3 paths must have the same length.');
    return;
  }
  for (int i = 0; i < filePaths.length; i++) {
    String filePath = filePaths[i];
    String preSignedUrl = preSignedUrls[i];

    try {
      File file = File(filePath);

      // Upload each file using the pre-signed URL
      final response = await dio.put(
        preSignedUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            'Content-Type': 'image/jpeg', // Adjust MIME type if necessary
          },
        ),
      );

      if (response.statusCode == 200) {
        print('File uploaded successfully to: $preSignedUrl');
      } else {
        print('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
