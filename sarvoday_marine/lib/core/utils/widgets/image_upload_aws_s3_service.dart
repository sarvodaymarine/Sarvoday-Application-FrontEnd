import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';

class ImageDetails {
  final XFile? image;
  final String imageName;
  final String imageId;

  ImageDetails(
      {required this.image, required this.imageName, required this.imageId});
}

class S3Service2 {
  Future<Either<String, List<Map<String, dynamic>>>> uploadMultipleImages(
      String reportId,
      String serviceReportId,
      String containerId,
      List<Map<String, dynamic>> images) async {
    try {
      DioClient dioClient = DioClient.getInstance();
      List<Map<String, dynamic>> updateImages = images
          .where((element) =>
              element.isNotEmpty &&
              element.containsKey('imageFile') &&
              element['imageFile'] != null &&
              element['imageFile'] != "")
          .toList();
      if (updateImages.isNotEmpty) {
        final response = await dioClient.post(
            '${StringConst.backEndBaseURL}reports/$reportId/serviceReportImage/$serviceReportId/containerReport/$containerId/uploadImages',
            data: updateImages.map((element) {
              Map<String, dynamic> copiedElement = Map.from(element);
              copiedElement.remove('imageFile');
              copiedElement.remove('error');
              copiedElement['fileName'] = element['imageName'];
              return copiedElement;
            }).toList());
        if (response.statusCode == 200) {
          List<bool> successes = [];
          List<Object> errors = [];
          List<Future<dynamic>> promise = [];
          for (int i = 0; i < updateImages.length; i++) {
            XFile? compressedImage =
                await _compressImage(File(updateImages[i]['imageFile']?.path));
            var byteData = await compressedImage?.readAsBytes();

            if (byteData != null) {
              Map<String, dynamic>? resultImage = images
                  .where((element) =>
                      element['imageId'] == updateImages[i]['imageId'])
                  .first;
              promise.add(dioClient
                  .put(
                response.data[i]['signedUrl'],
                data: byteData,
                authRequired: false,
                options: Options(
                  headers: {'Content-Type': 'image/jpeg'},
                  followRedirects: false,
                  validateStatus: (status) {
                    return status != null && status < 400;
                  },
                ),
              )
                  .then((r) {
                resultImage['imagePath'] = response.data[i]['path'];
                successes.add(true);
              }).catchError((e) {
                if (e is DioException) {
                  resultImage['error'] = e.message;
                } else {
                  resultImage['error'] = e.toString();
                }
                errors.add(e);
              }));
            }
          }

          await Future.wait(promise);
          if (errors.length == updateImages.length) {
            return const Left("Fail to upload image! please try again");
          } else if (successes.length == updateImages.length) {
            return const Left("success");
          } else {
            return Right(images);
          }
        } else {
          return const Left("Fail to upload image! please try again");
        }
      } else {
        return const Left("No images are available for upload");
      }
    } catch (error) {
      return const Left("Fail to upload image! please try again");
    }
  }

  Future<XFile?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.absolute.path, "temp.jpg");

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1080,
      minHeight: 1080,
    );

    if (result != null) {
      File resultFile = File(result.path);
      if (resultFile.lengthSync() > 1000000) {
        int quality = 90;
        while (resultFile.lengthSync() > 1000000 && quality > 10) {
          quality -= 10;
          result = await FlutterImageCompress.compressAndGetFile(
            file.absolute.path,
            targetPath,
            quality: quality,
            minWidth: 1080,
            minHeight: 1080,
          );
        }
      }
    }

    return result;
  }
}
