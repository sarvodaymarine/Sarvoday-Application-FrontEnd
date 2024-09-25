import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarvoday_marine/core/api_handler/api_handler_helper.dart';
import 'package:sarvoday_marine/core/api_handler/token_manager.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/string_const.dart';
import 'package:sarvoday_marine/features/authentication_module/data/data_sources/sign_in_data_source.dart';
import 'package:sarvoday_marine/features/authentication_module/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInDataSourceImpl implements SignInDataSource {
  final DioClient dio;
  final SharedPreferences sharedPreferences;

  SignInDataSourceImpl(this.dio, this.sharedPreferences);

  @override
  Future<Either<String, bool>> userLogin(String email, String password) async {
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
          return Right(((user.isFirstLogin ?? false) ||
              (user.isPasswordReset ?? false)));
        } else {
          dropLocalStorage();
          return const Left("Something went to wrong! Please try again later!");
        }
      } else {
        return Left(response.statusMessage.toString());
      }
    } catch (error) {
      return Left(CommonMethods.commonErrorHandler(error));
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
      final response =
          await dio.get('${StringConst.backEndBaseURL}users/$userUID/get');
      return response;
    }
  }

  @override
  Future<Either<bool, String>> resetPassword(String id) async {
    try {
      final response = await dio
          .post('${StringConst.backEndBaseURL}users/resetPassword/$id');
      if (response.statusCode == 200) {
        return left(true);
      } else {
        return right(response.statusMessage.toString());
      }
    } catch (error) {
      return right(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<String, UserModel>> getUserInfo() async {
    try {
      String? userUID = await TokenManager.getUserId();
      if (userUID != null && userUID.isNotEmpty) {
        final response =
            await dio.get('${StringConst.backEndBaseURL}users/$userUID/get');
        if (response.statusCode == 200) {
          final UserModel user = UserModel.fromJson(response.data);
          return Right(user);
        } else {
          return Left(CommonMethods.commonErrorHandler(response));
        }
      } else {
        return const Left("User not found");
      }
    } catch (error) {
      return Left(CommonMethods.commonErrorHandler(error));
    }
  }

  @override
  Future<Either<String, bool>> changePassword(String newPassword) async {
    try {
      String? userId = sharedPreferences.getString("userUid");
      if (userId != null && userId.isNotEmpty) {
        final response = await dio.post(
            '${StringConst.backEndBaseURL}users/$userId/changePassword',
            data: {'password': newPassword});
        if (response.statusCode == 200) {
          return const Right(true);
        } else {
          return Left(CommonMethods.commonErrorHandler(response));
        }
      } else {
        return const Left('User not found');
      }
    } catch (error) {
      return Left(CommonMethods.commonErrorHandler(error));
    }
  }
}
