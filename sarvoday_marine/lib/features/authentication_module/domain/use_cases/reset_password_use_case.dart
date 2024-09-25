import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/repositories/sign_in_repository.dart';

class ResetPasswordUseCase {
  final SignInRepository signInRepository;

  ResetPasswordUseCase(this.signInRepository);

  Future<Either<bool, String>> call(String id) async {
    return await signInRepository.resetPassword(id);
  }
}
