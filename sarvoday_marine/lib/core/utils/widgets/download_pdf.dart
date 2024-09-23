import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';

class DownloadPDFButton extends StatefulWidget {
  final String signedUrl;
  final String fileName;

  const DownloadPDFButton(
      {required this.signedUrl, required this.fileName, super.key});

  @override
  DownloadPDFButtonState createState() => DownloadPDFButtonState();
}

class DownloadPDFButtonState extends State<DownloadPDFButton> {
  bool _isDownloading = false;

  Future<String> _downloadPDF(BuildContext context) async {
    setState(() {
      _isDownloading = true;
    });
    final dio = Dio();
    final response = await dio.get(widget.signedUrl,
        options: Options(responseType: ResponseType.bytes));

    if (response.statusCode == 200) {
      if (context.mounted) {
        _requestStoragePermission(context);
      }
      final appDirectory = Platform.isAndroid
          ? await getDownloadsDirectory()
          : await getApplicationDocumentsDirectory();
      final file = File('${appDirectory?.path}/${widget.fileName}');
      file.writeAsBytes(response.data);
      setState(() {
        _isDownloading = false;
      });

      final result = await OpenFile.open(file.path);
      if (result.type == ResultType.done) {
        return 'PDF opened successfully!';
      } else if (result.type == ResultType.noAppToOpen) {
        return 'Failed to open PDF: There is no suitable app to open';
      }
      return 'Download failed.';
    } else {
      setState(() {
        _isDownloading = false;
      });
      return 'Download failed.';
    }
  }

  Future<bool> _requestStoragePermission(BuildContext context) async {
    var storageStatus = await Permission.storage.status;

    if (storageStatus.isDenied) {
      storageStatus = await Permission.storage.request();
    }

    if (storageStatus.isPermanentlyDenied) {
      if (context.mounted) {
        CommonMethods.showPermissionDialog(context);
      }
      return false;
    }

    if (storageStatus.isRestricted) {
      if (context.mounted) {
        CommonMethods.showToast(context,
            'Permission is restricted. You cannot access this feature.');
      }
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return GestureDetector(
      onTap: _isDownloading
          ? null
          : () async {
              await _downloadPDF(context);
            },
      child: _isDownloading
          ? Row(
              children: [
                SizedBox(
                    width: SmTextTheme.getResponsiveSize(context, 18),
                    height: SmTextTheme.getResponsiveSize(context, 18),
                    child: const CircularProgressIndicator()),
              ],
            )
          : Icon(
              Icons.download_sharp,
              color: SmCommonColors.secondaryColor,
              size: SmTextTheme.getResponsiveSize(context, 18),
            ),
    );
  }
}
