import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/use_cases/change_password_use_case.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/use_cases/login_use_case.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.loginUseCase, this.changePasswordUseCase)
      : super(SignInInitial());

  final LoginUseCase loginUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  // conform password change obSecure event
  obSecureEventChange(bool val) {
    emit(StateOnSuccess(!val));
  }

  obSecureEventChange2(bool val) {
    emit(StateOnSuccess2(!val));
  }

  signInCall(String email, String password) async {
    emit(StateLoading());
    var res = await loginUseCase.call(email, password);
    res.fold(
        (error) =>
            emit(StateErrorGeneral(CommonMethods.commonValidation(error))),
        (right) => emit(Authenticated(right)));
  }

  changedPassword(String password) async {
    emit(StateLoading());
    var res = await changePasswordUseCase.call(password);
    res.fold(
        (error) =>
            emit(StateErrorGeneral(CommonMethods.commonValidation(error))),
        (right) => emit(StateNoData()));
  }
}
