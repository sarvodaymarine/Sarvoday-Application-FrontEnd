import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/core/failure/common_failure.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/repositories/calendar_repository.dart';

class GetAllSalesOrderUseCases {
  final CalendarRepository calendarRepository;

  GetAllSalesOrderUseCases(this.calendarRepository);

  Future<Either<List<SalesOrderModel>, CommonFailure>> call() async {
    return await calendarRepository.getAllSalesOrder();
  }
}
