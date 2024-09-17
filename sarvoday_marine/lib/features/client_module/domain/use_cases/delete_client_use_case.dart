import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/client_module/domain/repositories/client_repository.dart';

class DeleteClientUseCase {
  final ClientRepository clientRepository;

  DeleteClientUseCase(this.clientRepository);

  Future<Either<bool, String>> call(String clientId) async {
    return await clientRepository.deleteClient(clientId);
  }
}
