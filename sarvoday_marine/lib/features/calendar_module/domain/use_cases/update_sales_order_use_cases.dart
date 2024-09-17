import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/repositories/calendar_repository.dart';

class UpdateSalesOrderUseCase {
  final CalendarRepository calendarRepository;

  UpdateSalesOrderUseCase(this.calendarRepository);

  Future<Either<SalesOrderModel, String>> call(
      String id, SalesOrderParam soParam) async {
    return await calendarRepository.updateSalesOrder(id, soParam);
  }
}
