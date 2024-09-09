import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/features/report_module/data/models/image_config_model.dart';
import 'package:sarvoday_marine/features/service_module/data/models/service_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/add_service_use_case.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/delete_service_use_case.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/get_all_services_use__case.dart';
import 'package:sarvoday_marine/features/service_module/domain/use_cases/update_service_use_case.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit(this.getAllServicesUseCase, this.addServiceUseCase,
      this.deleteServiceUseCase, this.updateServiceUseCase)
      : super(ServiceInitial()) {
    getAllServices();
  }

  final GetAllServicesUseCase getAllServicesUseCase;
  final AddServiceUseCase addServiceUseCase;
  final DeleteServiceUseCase deleteServiceUseCase;
  final UpdateServiceUseCase updateServiceUseCase;
  List<ServiceModel> tempService = [];

  getAllServices({bool needFetchData = false}) async {
    if (needFetchData) {
      emit(StateLoading());
    }
    var res = await getAllServicesUseCase.call();
    res.fold((services) {
      emit(StateOnSuccess(services));
    }, (error) {
      emit(StateErrorGeneral(CommonMethods.commonValidation(error)));
    });
  }

  addService(
      String serviceName,
      double container1Price,
      double container2Price,
      double container3Price,
      double container4Price,
      List<ImageConfig> images) async {
    emit(StateNoData());
    var res = await addServiceUseCase.call(AddServiceParam(
        serviceName,
        container1Price,
        container2Price,
        container3Price,
        container4Price,
        images));
    res.fold((services) {
      emit(StateOnCrudSuccess("Service Added SuccessFully"));
      getAllServices(needFetchData: true);
    }, (error) {
      emit(StateErrorGeneral(CommonMethods.commonValidation(error)));
    });
  }

  deleteService(String serviceId) async {
    emit(StateNoData());
    var res = await deleteServiceUseCase.call(serviceId);
    res.fold((services) {
      emit(StateOnCrudSuccess("Service deleted SuccessFully!"));
      getAllServices(needFetchData: true);
    }, (error) {
      emit(StateErrorGeneral(CommonMethods.commonValidation(error)));
    });
  }

  updatedService(
      String serviceId,
      String serviceName,
      double container1Price,
      double container2Price,
      double container3Price,
      double container4Price,
      List<ImageConfig> images) async {
    emit(StateNoData());
    if (serviceId.isNotEmpty) {
      if (serviceName.isEmpty &&
          container1Price.toString().isEmpty &&
          container2Price.toString().isEmpty &&
          container3Price.toString().isEmpty &&
          container4Price.toString().isEmpty) {
        emit(StateErrorGeneral(
            'Service data cannot be empty. Please provide the necessary information.'));
      } else {
        var res = await updateServiceUseCase.call(
            serviceId,
            AddServiceParam(serviceName, container1Price, container2Price,
                container3Price, container4Price, images));
        res.fold((services) {
          emit(StateOnCrudSuccess('Service updated Successfully!'));
          getAllServices(needFetchData: true);
        }, (error) {
          emit(StateErrorGeneral(CommonMethods.commonValidation(error)));
        });
      }
    } else {
      emit(StateErrorGeneral("Something went to wrong!"));
    }
  }
}
