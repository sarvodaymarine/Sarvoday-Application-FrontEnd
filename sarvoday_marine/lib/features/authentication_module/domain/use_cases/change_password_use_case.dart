import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/repositories/sign_in_repository.dart';

class ChangePasswordUseCase {
  final SignInRepository signInRepository;

  ChangePasswordUseCase(this.signInRepository);

  Future<Either<String, bool>> call(String password) async {
    return await signInRepository.changePassword(password);
  }
}
