import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_app_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_loading_dialog.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/core/utils/widgets/common_app_bar.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_button.dart';
import 'package:sarvoday_marine/features/authentication_module/authentication_injection_container.dart';
import 'package:sarvoday_marine/features/authentication_module/presentation/cubit/sign_in_cubit.dart';

@RoutePage()
class ChangePasswordPage extends StatelessWidget implements AutoRouteWrapper {
  ChangePasswordPage({super.key});

  final FormGroup form = FormGroup({
    'newPassword': FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
    'confirmPassword': FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
  }, validators: [
    Validators.mustMatch('newPassword', 'confirmPassword')
  ]);
  bool isObsecurePassword = true;
  bool isObsecureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
              context: context, title: StringConst.smPasswordChangeTitle)
          .appBar(),
      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is StateLoading) {
            showLoadingDialog(context);
          } else if (state is StateErrorGeneral) {
            hideLoadingDialog(context);
            CommonMethods.showCommonDialog(context, "Error", state.errorMsg);
          } else if (state is StateNoData) {
            context.router.replaceAll([const CalendarRoute()]);
          }
        },
        builder: (context, state) {
          if (state is StateOnSuccess) {
            isObsecurePassword = state.response;
          } else if (state is StateOnSuccess2) {
            isObsecureConfirmPassword = state.response;
          }
          return ReactiveForm(
              formGroup: form,
              child: Padding(
                padding: EdgeInsets.all(
                    SmTextTheme.getResponsiveSize(context, 24.0)),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 24.0),
                      ),
                      ReactiveTextField<String>(
                        formControlName: "newPassword",
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  SmTextTheme.getResponsiveSize(
                                      context, 16.0))),
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: SmAppTheme.isDarkMode(context)
                                  ? SmColorDarkTheme.secondaryTextColor
                                  : SmColorLightTheme.secondaryTextColor),
                          labelText: "New password",
                          suffixIcon: GestureDetector(
                              child: Icon(isObsecurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onTap: () {
                                context
                                    .read<SignInCubit>()
                                    .obSecureEventChange(isObsecurePassword);
                              }),
                        ),
                        obscureText: isObsecurePassword,
                        validationMessages: {
                          ValidationMessage.required: (error) =>
                              'New Password is required',
                          ValidationMessage.minLength: (error) =>
                              'New Password must be at least 8 characters',
                        },
                      ),
                      SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 18.0),
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'confirmPassword',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  SmTextTheme.getResponsiveSize(
                                      context, 16.0))),
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: SmAppTheme.isDarkMode(context)
                                  ? SmColorDarkTheme.secondaryTextColor
                                  : SmColorLightTheme.secondaryTextColor),
                          labelText: "Confirm Password",
                          suffixIcon: GestureDetector(
                              child: Icon(isObsecureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onTap: () {
                                context
                                    .read<SignInCubit>()
                                    .obSecureEventChange2(
                                        isObsecureConfirmPassword);
                              }),
                        ),
                        obscureText: isObsecureConfirmPassword,
                        validationMessages: {
                          ValidationMessage.required: (error) =>
                              'Confirm Password is required',
                          ValidationMessage.minLength: (error) =>
                              'Confirm Password must be at least 8 characters',
                          ValidationMessage.mustMatch: (error) =>
                              'Passwords do not match',
                        },
                      ),
                      SizedBox(
                        height: SmTextTheme.getResponsiveSize(context, 24.0),
                      ),
                      ReactiveFormConsumer(
                        builder: (context, form, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: CustomSmButton(
                              text: StringConst.changeButtonTxt,
                              onTap: () {
                                if (form.valid) {
                                  String password = form.value.toString();
                                  context
                                      .read<SignInCubit>()
                                      .changedPassword(password);
                                } else {
                                  form.markAllAsTouched();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  @override
  Widget wrappedRoute(context) {
    return BlocProvider(
      create: (context) => authenticationSl<SignInCubit>(),
      child: this,
    );
  }
}
