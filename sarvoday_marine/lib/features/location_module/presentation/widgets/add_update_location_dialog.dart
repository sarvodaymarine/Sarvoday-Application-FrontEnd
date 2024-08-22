import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/features/location_module/presentation/cubit/location_cubit.dart';

class AddUpdateLocationDialog {
  static showLocationDialog(BuildContext context2, bool isEditDialog,
      {String locationName = "",
      String address = "",
      String locationCode = '',
      String locationId = ""}) {
    final FormGroup form = FormGroup({
      "locationName": FormControl<String>(validators: [
        Validators.required,
      ], value: locationName),
      "address": FormControl<String>(validators: [
        Validators.required,
      ], value: address),
      "locationCode": FormControl<String>(validators: [
        Validators.required,
      ], value: locationCode),
    });
    return showDialog(
      context: context2,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: EdgeInsets.only(
                left: SmTextTheme.getResponsiveSize(context, 8.0),
                top: SmTextTheme.getResponsiveSize(context, 12.0)),
            child: RichText(
              text: TextSpan(
                  text: isEditDialog ? "Edit Location" : "Add Location",
                  style: SmTextTheme.labelStyle3(context)),
            ),
          ),
          content: Container(
            width: SmTextTheme.getResponsiveSize(context, 320),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    SmTextTheme.getResponsiveSize(context, 12.0))),
            child: ReactiveForm(
              formGroup: form,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 20.0)),
                      ReactiveTextField<String>(
                        formControlName: "locationName",
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          labelText: "Location Name",
                          labelStyle: TextStyle(
                              fontSize:
                                  SmTextTheme.getResponsiveSize(context, 16.0),
                              fontWeight: FontWeight.w400,
                              color: SmAppTheme.isDarkMode(context)
                                  ? SmColorDarkTheme.secondaryTextColor
                                  : SmColorLightTheme.secondaryTextColor),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (error) =>
                              "Location Name is Required",
                        },
                      ),
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 20.0)),
                      ReactiveTextField<String>(
                        formControlName: "locationCode",
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            labelText: "Location Code",
                            labelStyle: TextStyle(
                                fontSize: SmTextTheme.getResponsiveSize(
                                    context, 16.0),
                                fontWeight: FontWeight.w400,
                                color: SmAppTheme.isDarkMode(context)
                                    ? SmColorDarkTheme.secondaryTextColor
                                    : SmColorLightTheme.secondaryTextColor)),
                        validationMessages: {
                          ValidationMessage.required: (error) =>
                              "Location code is Required",
                        },
                      ),
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 20.0)),
                      ReactiveTextField<String>(
                        minLines: 5,
                        maxLines: 7,
                        formControlName: "address",
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            labelText: "Address",
                            labelStyle: TextStyle(
                                fontSize: SmTextTheme.getResponsiveSize(
                                    context, 16.0),
                                fontWeight: FontWeight.w400,
                                color: SmAppTheme.isDarkMode(context)
                                    ? SmColorDarkTheme.secondaryTextColor
                                    : SmColorLightTheme.secondaryTextColor)),
                        validationMessages: {
                          ValidationMessage.required: (error) =>
                              "Address is Required",
                        },
                      ),
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 20.0)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: RichText(
                  text: TextSpan(
                      text: 'Cancel',
                      style: SmTextTheme.cancelButtonTextStyle(context)
                          .copyWith(
                              fontSize:
                                  SmTextTheme.getResponsiveSize(context, 14)))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: RichText(
                  text: TextSpan(
                      text: 'Submit',
                      style: SmTextTheme.confirmButtonTextStyle(context)
                          .copyWith(
                              fontSize:
                                  SmTextTheme.getResponsiveSize(context, 14)))),
              onPressed: () async {
                if (form.valid) {
                  if (isEditDialog) {
                    context2.read<LocationCubit>().updatedLocation(
                        locationId,
                        form.control("locationName").value,
                        form.control('address').value,
                        form.control("locationCode").value);
                  } else {
                    await context2.read<LocationCubit>().addLocation(
                        form.control("locationName").value,
                        form.control('address').value,
                        form.control('locationCode').value);
                  }
                } else {
                  form.markAllAsTouched();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
