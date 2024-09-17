import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/client_module/domain/repositories/client_repository.dart';

class DisableEnabledClientAuthUseCase {
  final ClientRepository clientRepository;

  DisableEnabledClientAuthUseCase(this.clientRepository);

  Future<Either<bool, String>> call(String clientId, bool isActive) async {
    return await clientRepository.disableEnableClient(clientId, isActive);
  }
}
