import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkAuthentication() async {
    try {
      emit(AuthLoading());
      DioClient dioClient = DioClient.getInstance();
      await dioClient.post(
          '${StringConst.backEndBaseURL}users/validateUserToken',
          data: {});
      emit(Authenticated());
    } catch (e) {
      emit(UnAuthenticated());
    }
  }
}
