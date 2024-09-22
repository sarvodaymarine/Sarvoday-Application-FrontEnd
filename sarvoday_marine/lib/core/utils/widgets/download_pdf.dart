import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';

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

  Future<String> _downloadPDF() async {
    setState(() {
      _isDownloading = true;
    });
    final dio = Dio();
    final response = await dio.get(widget.signedUrl,
        options: Options(responseType: ResponseType.plain));

    if (response.statusCode == 200) {
      final appDirectory = await getApplicationDocumentsDirectory();
      final file = File('${appDirectory.path}/${widget.fileName}');
      var responseData = response.data;

      if (responseData is String) {
        Uint8List bodyBytes = Uint8List.fromList(responseData.codeUnits);

        await file.writeAsBytes(bodyBytes);
      } else if (responseData is Uint8List) {
        await file.writeAsBytes(responseData);
      }

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

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return GestureDetector(
      onTap: _isDownloading ? null : _downloadPDF,
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
