import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/repositories/calendar_repository.dart';

class GetSalesOrderUseCases {
  final CalendarRepository calendarRepository;

  GetSalesOrderUseCases(this.calendarRepository);

  Future<Either<SalesOrderModel, String>> call(String id) async {
    return await calendarRepository.getSalesOrder(id);
  }
}
