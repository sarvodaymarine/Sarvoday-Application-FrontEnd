import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/report_module/data/models/image_config_model.dart';
import 'package:sarvoday_marine/features/service_module/domain/repositories/service_repository.dart';

class AddServiceUseCase {
  final ServiceRepository serviceRepository;

  AddServiceUseCase(this.serviceRepository);

  Future<Either<bool, String>> call(AddServiceParam addServiceParam) async {
    return await serviceRepository.addService(addServiceParam);
  }
}

class AddServiceParam {
  String? serviceName;
  double? container1Price;
  double? container2Price;
  double? container3Price;
  double? container4Price;
  List<ImageConfig> images;

  AddServiceParam(this.serviceName, this.container1Price, this.container2Price,
      this.container3Price, this.container4Price, this.images);
}
