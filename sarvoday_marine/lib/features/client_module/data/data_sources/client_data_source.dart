import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/client_module/data/models/client_model.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/add_client_use_case.dart';

abstract class ClientDataSource {
  Future<Either<List<ClientModel>, String>> getAllClients();

  Future<Either<bool, String>> addClient(ClientParam clientParam);

  Future<Either<bool, String>> deleteClient(String clientId);

  Future<Either<bool, String>> disableEnableClient(
      String clientId, bool isActive);

  Future<Either<ClientModel, String>> updateClient(
      String clientId, ClientParam clientParam);
}
