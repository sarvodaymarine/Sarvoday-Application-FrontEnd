import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/add_client_use_case.dart';

abstract class ClientRepository {
  Future<Either<List<ClientModel>, CommonFailure>> getAllClients();

  Future<Either<bool, CommonFailure>> addClient(ClientParam clientParam);

  Future<Either<bool, CommonFailure>> deleteClient(String clientId);

  Future<Either<bool, CommonFailure>> disableEnableClient(String clientId, bool isActive);

  Future<Either<ClientModel, CommonFailure>> updateClient(
      String clientId, ClientParam clientParam);
}
