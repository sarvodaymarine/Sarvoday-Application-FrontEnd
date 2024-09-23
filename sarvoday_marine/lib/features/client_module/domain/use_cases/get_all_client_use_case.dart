import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/domain/repositories/client_repository.dart';

class GetAllClientsUseCase {
  final ClientRepository clientRepository;

  GetAllClientsUseCase(this.clientRepository);

  Future<Either<List<ClientModel>, String>> call() async {
    return await clientRepository.getAllClients();
  }
}
