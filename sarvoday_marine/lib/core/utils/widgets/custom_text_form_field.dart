import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.formControlName,
      required this.labelText,
      this.hintText,
      this.validationMessages,
      this.isValidationRequired = true,
      this.isReadOnly = false,
      this.onTap,
      this.maxLines = 1,
      this.minLines = 1,
      this.keyboardType});

  final String formControlName;
  final String labelText;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final bool isValidationRequired;
  final bool isReadOnly;
  final void Function(FormControl<dynamic>)? onTap;
  final TextInputType? keyboardType;
  final Map<String, String Function(Object)>? validationMessages;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      onTap: onTap,
      style: SmTextTheme.textInputStyle(context),
      readOnly: isReadOnly,
      maxLines: maxLines,
      minLines: minLines,
      formControlName: formControlName,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
        labelText: labelText,
        hintText: hintText,
        hintStyle: SmTextTheme.hintTextStyle(context),
        labelStyle: SmTextTheme.infoContentStyle6(context),
      ),
      validationMessages: isValidationRequired
          ? validationMessages ??
              {
                ValidationMessage.required: (error) => "$labelText is Required",
              }
          : null,
    );
  }
}
