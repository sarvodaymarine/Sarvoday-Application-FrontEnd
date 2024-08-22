import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
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

  static commonValidation(dynamic error) {
    if (error is InternetFailure) {
      return error.failureMsg;
    } else if (error is ServerFailure || error is SocketException) {
      return "Server Failure! Please try again in sometime";
    } else if (error is DioException) {
      return (error.response?.data['message'] ??
              error.response?.statusMessage ??
              error.error ??
              '')
          .toString();
    } else if (error is ErrorFailure) {
      return error.errorMsg;
    } else if (error is AuthFailure) {
      return error.authFailureMsg;
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
