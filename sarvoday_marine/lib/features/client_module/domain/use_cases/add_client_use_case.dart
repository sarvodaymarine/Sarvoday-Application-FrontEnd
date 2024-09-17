import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/client_module/domain/repositories/client_repository.dart';

class AddClientUseCase {
  final ClientRepository clientRepository;

  AddClientUseCase(this.clientRepository);

  Future<Either<bool, String>> call(ClientParam clientParam) async {
    return await clientRepository.addClient(clientParam);
  }
}

class ClientParam {
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? countryCode;
  String? clientAddress;
  List<Map<String, dynamic>>? services;

  ClientParam(this.firstName, this.lastName, this.email, this.mobile,
      this.countryCode, this.clientAddress, this.services);
}
