import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/add_client_use_case.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/delete_client_use_case.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/disable_client_auth_use_case.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/get_all_client_use_case.dart';
import 'package:sarvoday_marine/features/client_module/domain/use_cases/update_client_use_case.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';

part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  ClientCubit(
      this.getAllClientsUseCase,
      this.addClientUseCase,
      this.deleteClientUseCase,
      this.updateClientUseCase,
      this.disableClientAuthUseCase)
      : super(ClientInitial());

  final GetAllClientsUseCase getAllClientsUseCase;
  final AddClientUseCase addClientUseCase;
  final DeleteClientUseCase deleteClientUseCase;
  final UpdateClientUseCase updateClientUseCase;
  final DisableEnabledClientAuthUseCase disableClientAuthUseCase;

  getAllClient({bool needFetchData = false}) async {
    if (needFetchData) {
      emit(CStateLoading());
    }
    var res = await getAllClientsUseCase.call();
    res.fold((client) {
      emit(CStateOnSuccess(client));
    }, (error) {
      emit(CStateErrorGeneral(error.toString()));
    });
  }

  addServiceUiChange(List<ServiceModel> services, ServiceModel updatedService) {
    services.remove(updatedService);
    emit(CStateOnSuccess2(services));
  }

  addClient(
      String firstName,
      String lastName,
      String email,
      String countryCode,
      String mobile,
      String clientAddress,
      List<Map<String, dynamic>> services) async {
    emit(CStateNoData());
    var res = await addClientUseCase.call(ClientParam(firstName, lastName,
        email, mobile, countryCode, clientAddress, services));
    res.fold((client) {
      emit(CStateOnCrudSuccess("Client Added SuccessFully"));
      getAllClient(needFetchData: true);
    }, (error) {
      emit(CStateErrorGeneral(error.toString()));
    });
  }

  deleteClient(String clientId) async {
    emit(CStateNoData());
    var res = await deleteClientUseCase.call(clientId);
    res.fold((client) {
      emit(CStateOnCrudSuccess("Client deleted SuccessFully!"));
      getAllClient(needFetchData: true);
    }, (error) {
      emit(CStateErrorGeneral(error.toString()));
    });
  }

  disableClient(String clientId, bool isActive) async {
    emit(CStateNoData());
    var res = await disableClientAuthUseCase.call(clientId, isActive);
    res.fold((client) {
      emit(CStateOnCrudSuccess(
          isActive ? "Client is authentication activated!" : "Client disabled!"));
      getAllClient(needFetchData: true);
    }, (error) {
      emit(CStateErrorGeneral(error.toString()));
    });
  }

  updateClient(
      String clientId,
      String firstName,
      String lastName,
      String mobile,
      String email,
      String countryCode,
      String clientAddress,
      List<Map<String, dynamic>> services) async {
    emit(CStateNoData());
    if (clientId.isNotEmpty) {
      if (firstName.isEmpty &&
          lastName.isEmpty &&
          mobile.isEmpty &&
          countryCode.isEmpty &&
          email.isEmpty &&
          clientAddress.isEmpty) {
        emit(CStateErrorGeneral(
            'Client data cannot be empty. Please provide the necessary information.'));
      } else {
        var res = await updateClientUseCase.call(
            clientId,
            ClientParam(firstName, lastName, email, mobile, countryCode,
                clientAddress, services));
        res.fold((client) {
          emit(CStateOnCrudSuccess('Client updated Successfully!'));
          getAllClient(needFetchData: true);
        }, (error) {
          emit(CStateErrorGeneral(error.toString()));
        });
      }
    } else {
      emit(CStateErrorGeneral("Something went to wrong!"));
    }
  }
}
