import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sarvoday_marine/core/api_handler/dio_error_handler.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/constants/image_path_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonMethods {
  static showToast(BuildContext context, String msg) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: SmCommonColors.secondaryColor,
      textColor: SmColorLightTheme.textColor,
      fontSize: SmTextTheme.getResponsiveSize(context, 14.0),
    );
  }

  static showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
            'Permissions are permanently denied. Please enable them in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  static getImageFromLocalPath(String imagePath) {
    return Image.file(
      File(imagePath),
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Image.asset(ImagePathConst.imageHolder);
      },
      fit: BoxFit.fill,
    );
  }

  static getNetworkImage(String imageUrl) {
    return Image.network(
      imageUrl,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
              child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ));
        }
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Image.asset(ImagePathConst.imageHolder);
      },
      fit: BoxFit.fill,
    );
  }

  static showCommonDialog(
      BuildContext context, String title, String description) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: RichText(
            text:
                TextSpan(text: title, style: SmTextTheme.labelStyle2(context)),
          ),
          content: Container(
            width: SmTextTheme.getResponsiveSize(context, 280),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    SmTextTheme.getResponsiveSize(context, 12.0))),
            child: RichText(
              text: TextSpan(
                  text: description,
                  style: SmTextTheme.labelDescriptionStyle(context)),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: RichText(
                  text: TextSpan(
                      text: 'Okay',
                      style: SmTextTheme.confirmButtonTextStyle(context)
                          .copyWith(
                              fontSize:
                                  SmTextTheme.getResponsiveSize(context, 14)))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showCommonDialogWithChild(
      BuildContext context, String title, Widget child,
      {String? negativeButtonString, String? positiveButtonString}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: RichText(
            text: TextSpan(
                text: title,
                style: SmTextTheme.labelStyle2(context).copyWith(
                    fontSize: SmTextTheme.getResponsiveSize(context, 20))),
          ),
          content: child,
          actions: <Widget>[
            if (negativeButtonString != null && negativeButtonString.isNotEmpty)
              TextButton(
                child: RichText(
                    text: TextSpan(
                        text: negativeButtonString,
                        style: SmTextTheme.cancelButtonTextStyle(context)
                            .copyWith(
                                fontSize: SmTextTheme.getResponsiveSize(
                                    context, 14)))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: RichText(
                  text: TextSpan(
                      text: positiveButtonString ?? 'Okay',
                      style: SmTextTheme.confirmButtonTextStyle(context)
                          .copyWith(
                              fontSize:
                                  SmTextTheme.getResponsiveSize(context, 14)))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static String commonErrorHandler(dynamic error) {
    if (error is DioException) {
      return DioErrorHandler.handleDioError(error);
    } else {
      return error.toString();
    }
  }

  static Future<Options?> getAuthenticationToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('userToken');
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  static DateTime normalizeDateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static commonShowCountryPicker(
      BuildContext context, FormControl value, FormGroup form) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        form.control('countryCode').value = '+${country.phoneCode}';
      },
    );
  }
}
