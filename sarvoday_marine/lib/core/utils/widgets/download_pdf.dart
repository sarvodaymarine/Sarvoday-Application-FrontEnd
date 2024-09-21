import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';

class DownloadPDFButton extends StatefulWidget {
  final String signedUrl;

  const DownloadPDFButton({required this.signedUrl, super.key});

  @override
  DownloadPDFButtonState createState() => DownloadPDFButtonState();
}

class DownloadPDFButtonState extends State<DownloadPDFButton> {
  bool _isDownloading = false;
  String _downloadStatus = '';

  Future<String> _downloadPDF() async {
    setState(() {
      _isDownloading = true;
      _downloadStatus = 'Downloading...';
    });
    final dio = DioClient.getInstance();
    final response = await dio.get(widget.signedUrl);

    if (response.statusCode == 200) {
      final appDirectory = await getApplicationDocumentsDirectory();
      final file = File(
          '${appDirectory.path}/downloads/${widget.signedUrl.split('/').last}');

      await file.writeAsBytes(response.data["bodyBytes"]);

      setState(() {
        _isDownloading = false;
        _downloadStatus = 'Download completed!';
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
        _downloadStatus = 'Download failed.';
      });
      return 'Download failed.';
    }
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return ElevatedButton(
      onPressed: _isDownloading ? null : _downloadPDF,
      child: _isDownloading
          ? Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 10),
                Text(_downloadStatus),
              ],
            )
          : Icon(
              Icons.download_sharp,
              color: SmCommonColors.secondaryColor,
              size: SmTextTheme.getResponsiveSize(context, 14),
            ),
    );
  }
}
