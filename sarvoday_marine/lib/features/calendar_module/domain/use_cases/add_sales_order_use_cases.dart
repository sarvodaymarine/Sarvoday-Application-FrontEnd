import 'package:dartz/dartz.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/repositories/calendar_repository.dart';

class AddSalesOrderUseCase {
  final CalendarRepository calendarRepository;

  AddSalesOrderUseCase(this.calendarRepository);

  Future<Either<bool, String>> call(SalesOrderParam salesOrderParam) async {
    return await calendarRepository.addSalesOrder(salesOrderParam);
  }
}
