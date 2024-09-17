import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/authentication_module/data/data_sources/sign_in_data_source.dart';
import 'package:sarvoday_marine/features/authentication_module/data/models/user_model.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/repositories/sign_in_repository.dart';

class SignInRepositoryImpl implements SignInRepository {
  final SignInDataSource signInDataSource;

  SignInRepositoryImpl(this.signInDataSource);

  @override
  Future<Either<String, bool>> userLogin(String email, String password) async {
    return await signInDataSource.userLogin(email, password);
  }

  @override
  Future<Either<String, UserModel>> getUserInfo() async {
    return await signInDataSource.getUserInfo();
  }

  @override
  Future<Either<String, bool>> changePassword(String password) async {
    return await signInDataSource.changePassword(password);
  }
}
