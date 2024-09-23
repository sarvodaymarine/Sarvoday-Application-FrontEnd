import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/authentication_module/domain/repositories/sign_in_repository.dart';

class LoginUseCase {
  final SignInRepository signInRepository;

  LoginUseCase(this.signInRepository);

  Future<Either<String, bool>> call(String email, String password) async {
    return await signInRepository.userLogin(email, password);
  }
}
