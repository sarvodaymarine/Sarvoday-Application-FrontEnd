import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/authentication_module/data/data_sources/sign_in_data_source.dart';
import 'package:dio/dio.dart';
import 'package:sarvoday_marine/features/authentication_module/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInDataSourceImpl implements SignInDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  SignInDataSourceImpl(this.dio, this.sharedPreferences);

  @override
  Future<Either<CommonFailure, bool>> userLogin(
      String email, String password) async {
    try {
      Map<String, dynamic> loginCredential = {
        "email": email,
        "password": password
      };
      final response = await dio.post(
          '${StringConst.backEndBaseURL}users/userLogin',
          data: loginCredential);
      if (response.statusCode == 200) {
        extractUserId(response.data);
        final apiResponse = await userApiCall();
        if (apiResponse.statusCode == 200) {
          final UserModel user = UserModel.fromJson(apiResponse.data);
          return Right(user.isFirstLogin ?? false);
        } else {
          dropLocalStorage();
          return Left(
              ErrorFailure("Something went to wrong! Please try again later!"));
        }
      } else {
        return Left(ErrorFailure(response.statusMessage.toString()));
      }
    } catch (error) {
      return Left(ErrorFailure(CommonMethods.commonValidation(error)));
    }
  }

  extractUserId(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    String userId = decodedToken['id'];
    String userType = decodedToken['userRole'];
    sharedPreferences.setString("userToken", token);
    sharedPreferences.setString("userUid", userId);
    sharedPreferences.setString("userType", userType);
  }

  dropLocalStorage() {
    sharedPreferences.clear();
  }

  userApiCall() async {
    String? userUID = sharedPreferences.getString("userUid");
    String? token = sharedPreferences.getString("userToken");
    if (userUID != null &&
        userUID.isNotEmpty &&
        token != null &&
        token.isNotEmpty) {
      final response = await dio.get(
          '${StringConst.backEndBaseURL}users/$userUID/get',
          options: await CommonMethods.getAuthenticationToken());
      return response;
    }
  }

  @override
  Future<Either<CommonFailure, UserModel>> getUserInfo() async {
    try {
      String? token = sharedPreferences.getString('userToken');
      String? userUID = sharedPreferences.getString("userUid");
      if (userUID != null &&
          userUID.isNotEmpty &&
          token != null &&
          token.isNotEmpty) {
        final response = await dio.get(
            '${StringConst.backEndBaseURL}users/$userUID/get',
            options: await CommonMethods.getAuthenticationToken());
        if (response.statusCode == 200) {
          final UserModel user = UserModel.fromJson(response.data);
          return Right(user);
        } else {
          return Left(ErrorFailure(response.statusMessage.toString()));
        }
      } else {
        return Left(AuthFailure());
      }
    } catch (error) {
      return Left(ErrorFailure(error.toString()));
    }
  }

  @override
  Future<Either<CommonFailure, bool>> changePassword(String newPassword) async {
    try {
      String? userId = sharedPreferences.getString("userUid");
      if (userId != null && userId.isNotEmpty) {
        final response = await dio.post(
            '${StringConst.backEndBaseURL}users/$userId/changePassword',
            options: await CommonMethods.getAuthenticationToken(),
            data: {'password': newPassword});
        if (response.statusCode == 200) {
          return const Right(true);
        } else {
          return Left(ErrorFailure(response.statusMessage.toString()));
        }
      } else {
        return Left(AuthFailure());
      }
    } catch (error) {
      return Left(ErrorFailure(error.toString()));
    }
  }
}
