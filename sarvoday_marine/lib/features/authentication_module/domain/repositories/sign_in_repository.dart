import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/authentication_module/data/models/user_model.dart';

abstract class SignInRepository {
  Future<Either<CommonFailure, bool>> userLogin(String email, String password);

  Future<Either<CommonFailure, bool>> changePassword(String password);

  Future<Either<CommonFailure, UserModel>> getUserInfo();
}
