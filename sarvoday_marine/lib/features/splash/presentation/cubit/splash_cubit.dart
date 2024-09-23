import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkAuthentication() async {
    emit(AuthLoading());
    try {
      DioClient dioClient = DioClient.getInstance();

      final response = await dioClient.post(
        '${StringConst.backEndBaseURL}users/validateUserToken',
        data: {},
      );

      if (response.statusCode == 200) {
        emit(Authenticated());
      } else {
        emit(UnAuthenticated());
      }
    } catch (dioError) {
      if (dioError is DioException &&
          dioError.response != null &&
          dioError.response!.data != null &&
          dioError.response!.data['status'] == 401) {
        emit(UnAuthenticated());
      } else {
        emit(AuthError(CommonMethods.commonErrorHandler(dioError)));
      }
    }
  }
}
