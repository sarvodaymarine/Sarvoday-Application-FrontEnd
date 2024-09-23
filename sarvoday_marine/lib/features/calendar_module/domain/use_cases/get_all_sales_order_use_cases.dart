import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/repositories/calendar_repository.dart';

class GetAllSalesOrderUseCases {
  final CalendarRepository calendarRepository;

  GetAllSalesOrderUseCases(this.calendarRepository);

  Future<Either<List<SalesOrderModel>, String>> call(
      DateTime startDateOfWeek, DateTime lastDateOfWeek) async {
    return await calendarRepository.getAllSalesOrder(
        startDateOfWeek, lastDateOfWeek);
  }
}
