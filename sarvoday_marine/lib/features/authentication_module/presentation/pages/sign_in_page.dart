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
import 'package:sarvoday_marine/core/utils/common/form_keys.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/core/utils/widgets/custom_sm_button.dart';
import 'package:sarvoday_marine/features/authentication_module/authentication_injection_container.dart';
import 'package:sarvoday_marine/features/authentication_module/presentation/cubit/sign_in_cubit.dart';

@RoutePage()
class SignInPage extends StatelessWidget implements AutoRouteWrapper {
  SignInPage({super.key});

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget wrappedRoute(context) {
    return BlocProvider(
      create: (context) => authenticationSl<SignInCubit>(),
      child: this,
    );
  }

  final FormGroup signInForm = FormGroup({
    FormKeys.userEmail: FormControl<String>(
      validators: [
        Validators.required,
        Validators.email,
      ],
    ),
    FormKeys.userPassword: FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(8),
      ],
    ),
  });
  bool passwordObSecure = true;

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return Scaffold(
      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is StateLoading) {
            showLoadingDialog(context);
          } else if (state is Authenticated) {
            hideLoadingDialog(context);
            CommonMethods.showToast(context, "User login successful!");
            if (state.isFirstTime) {
              context.router.replaceAll([ChangePasswordRoute()]);
            } else {
              context.router.replaceAll([CalendarRoute()]);
            }
          } else if (state is StateErrorGeneral) {
            hideLoadingDialog(context);
            CommonMethods.showCommonDialog(context, "Error", state.errorMsg);
          }
        },
        builder: (context, state) {
          if (state is StateOnSuccess) {
            passwordObSecure = state.response;
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ReactiveForm(
                  formGroup: signInForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: SmTextTheme.getResponsiveSize(context, 72.0),
                            left: SmTextTheme.getResponsiveSize(context, 20.0)),
                        child: RichText(
                            text: TextSpan(
                                text: StringConst.signIn,
                                style:
                                    SmTextTheme.labelNameTextStyle(context))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SmTextTheme.getResponsiveSize(context, 20.0),
                            left: SmTextTheme.getResponsiveSize(context, 20.0),
                            right: SmTextTheme.getResponsiveSize(context, 20.0),
                            bottom:
                                SmTextTheme.getResponsiveSize(context, 42.0)),
                        child: RichText(
                            text: TextSpan(
                                text: StringConst.signInInfoTxt,
                                style: SmTextTheme.hintTextStyle(context))),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                SmTextTheme.getResponsiveSize(context, 12.0),
                            horizontal:
                                SmTextTheme.getResponsiveSize(context, 16.0)),
                        child: ReactiveTextField<String>(
                          formControlName: FormKeys.userEmail,
                          onSubmitted: (term) {
                            _fieldFocusChange(
                                context, _emailFocus, _passwordFocus);
                          },
                          focusNode: _emailFocus,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      SmTextTheme.getResponsiveSize(
                                          context, 16.0))),
                              labelText: StringConst.email,
                              labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: SmAppTheme.isDarkMode(context)
                                      ? SmColorDarkTheme.secondaryTextColor
                                      : SmColorLightTheme.secondaryTextColor),
                              fillColor: SmCommonColors.fieldFillColor),
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                StringConst.emailEmptyErrMsg,
                            ValidationMessage.email: (error) =>
                                StringConst.emailInValidErrMsg,
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                SmTextTheme.getResponsiveSize(context, 12.0),
                            horizontal:
                                SmTextTheme.getResponsiveSize(context, 16.0)),
                        child: ReactiveTextField<String>(
                          formControlName: FormKeys.userPassword,
                          onSubmitted: (term) {
                            _fieldFocusChange(
                                context, _passwordFocus, _emailFocus);
                          },
                          focusNode: _passwordFocus,
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
                            labelText: StringConst.password,
                            suffixIcon: GestureDetector(
                                child: Icon(passwordObSecure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onTap: () {
                                  context
                                      .read<SignInCubit>()
                                      .obSecureEventChange(passwordObSecure);
                                }),
                          ),
                          obscureText: passwordObSecure,
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                StringConst.passwordEmptyErrMsg,
                            ValidationMessage.minLength: (error) =>
                                StringConst.passwordInValidErrMsg,
                          },
                        ),
                      ),
                      SizedBox(
                          height: SmTextTheme.getResponsiveSize(context, 24.0)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                SmTextTheme.getResponsiveSize(context, 16.0)),
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomSmButton(
                            text: StringConst.loginButtonTxt,
                            onTap: () {
                              if (signInForm.valid) {
                                String email = signInForm
                                    .control(FormKeys.userEmail)
                                    .value;
                                String password = signInForm
                                    .control(FormKeys.userPassword)
                                    .value;
                                context
                                    .read<SignInCubit>()
                                    .signInCall(email, password);
                              } else {
                                signInForm.markAllAsTouched();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
