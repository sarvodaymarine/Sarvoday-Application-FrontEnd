import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/domain/repositories/client_repository.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/add_client_use_case.dart';

class UpdateClientUseCase {
  final ClientRepository clientRepository;

  UpdateClientUseCase(this.clientRepository);

  Future<Either<ClientModel, String>> call(
      String clientId, ClientParam clientParam) async {
    return await clientRepository.updateClient(clientId, clientParam);
  }
}
