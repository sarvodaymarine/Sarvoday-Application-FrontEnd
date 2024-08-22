import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/client_module/data/data_sources/client_data_source.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/domain/repositories/client_repository.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/add_client_use_case.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientDataSource clientDataSource;

  ClientRepositoryImpl(this.clientDataSource);

  @override
  Future<Either<bool, CommonFailure>> addClient(ClientParam clientParam) async {
    return await clientDataSource.addClient(clientParam);
  }

  @override
  Future<Either<bool, CommonFailure>> deleteClient(String serviceId) async {
    return await clientDataSource.deleteClient(serviceId);
  }

  @override
  Future<Either<List<ClientModel>, CommonFailure>> getAllClients() async {
    return await clientDataSource.getAllClients();
  }

  @override
  Future<Either<ClientModel, CommonFailure>> updateClient(
      String serviceId, ClientParam clientParam) async {
    return await clientDataSource.updateClient(serviceId, clientParam);
  }

  @override
  Future<Either<bool, CommonFailure>> disableEnableClient(String clientId, bool isActive) async {
    return await clientDataSource.disableEnableClient(clientId, isActive);
  }
}
