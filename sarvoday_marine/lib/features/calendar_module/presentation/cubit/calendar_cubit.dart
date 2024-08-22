import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/sales_order_model.dart';
import 'package:sarvoday_marine/features/calendar_module/data/models/so_param_model.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/use_cases/add_sales_order_use_cases.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/use_cases/get_all_sales_order_use_cases.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/use_cases/get_sales_order_use_case.dart';
import 'package:sarvoday_marine/features/calendar_module/domain/use_cases/update_sales_order_use_cases.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit(this.addSalesOrderUseCase, this.getAllSalesOrderUseCases,
      this.getSalesOrderUseCases, this.updateSalesOrderUseCase)
      : super(CMCalendarInitial());
  final AddSalesOrderUseCase addSalesOrderUseCase;
  final GetAllSalesOrderUseCases getAllSalesOrderUseCases;
  final UpdateSalesOrderUseCase updateSalesOrderUseCase;
  final GetSalesOrderUseCases getSalesOrderUseCases;
  String? userType = '';

  getAllSalesOrders(
      {bool needFetchData = false, bool isFromCalendar = false}) async {
    if (needFetchData) {
      emit(CMStateLoading());
    }
    Map<DateTime, List<SalesOrderModel>> calendarSalesOrder = {};
    var res = await getAllSalesOrderUseCases.call();
    res.fold((orders) {
      if (isFromCalendar) {
        for (var event in orders) {
          DateTime date = CommonMethods.normalizeDateTime(
              DateTime.parse(event.orderDate!).toLocal());
          if (calendarSalesOrder.containsKey(date)) {
            calendarSalesOrder[date]!.add(event);
          } else {
            calendarSalesOrder[date] = [event];
          }
        }
      }
      emit(CMStateOnSuccess(isFromCalendar ? calendarSalesOrder : orders));
    }, (error) {
      emit(CMStateErrorGeneral(error.toString()));
    });
  }

  getSalesOrders(String id) async {
    emit(CMStateLoading());
    var res = await getSalesOrderUseCases.call(id);
    res.fold((orders) {
      emit(CMStateOnSuccess(orders));
    }, (error) {
      emit(CMStateErrorGeneral(error.toString()));
    });
  }

  calendarUiChanged(DateTime selectedDay, DateTime focusDay) {
    emit(CMStateOnCrudSuccess2(
        {"selectedDay": selectedDay, "focusDay": focusDay}));
  }

  addSalesOrders(
      String locationName,
      String locationAddress,
      String comment,
      String clientId,
      DateTime orderDate,
      String products,
      int noOfContainer,
      List<SoServiceParam> services,
      List<SoEmployeeParam> employeeList,
      List<ExpenseParam> otherExpenses,
      List<TaxParam> taxList,
      String clientName) async {
    emit(CMStateNoData());
    var res = await addSalesOrderUseCase.call(SalesOrderParam(
        locationName: locationName,
        clientId: clientId,
        orderDate: orderDate,
        noOfContainer: noOfContainer,
        products: products,
        services: services,
        employeeList: employeeList,
        clientName: clientName,
        comments: comment,
        locationAddress: locationAddress,
        otherExpenses: otherExpenses,
        tax: taxList));
    res.fold((location) {
      emit(const CMStateOnCrudSuccess("Sales Order created SuccessFully"));
    }, (error) {
      emit(CMStateErrorGeneral(error.toString()));
    });
  }

  updateSalesOrders(
      String soId,
      String locationName,
      String locationAddress,
      String comment,
      String clientId,
      DateTime orderDate,
      String products,
      int noOfContainer,
      List<SoServiceParam> services,
      List<SoEmployeeParam> employeeList,
      List<ExpenseParam> otherExpenses,
      List<TaxParam> taxList,
      String clientName) async {
    emit(CMStateNoData());
    var res = await updateSalesOrderUseCase.call(
        soId,
        SalesOrderParam(
            locationName: locationName,
            clientId: clientId,
            orderDate: orderDate,
            noOfContainer: noOfContainer,
            products: products,
            services: services,
            employeeList: employeeList,
            clientName: clientName,
            comments: comment,
            locationAddress: locationAddress,
            otherExpenses: otherExpenses,
            tax: taxList));
    res.fold((location) {
      emit(const CMStateOnCrudSuccess("Sales Order updated SuccessFully"));
    }, (error) {
      emit(CMStateErrorGeneral(error.toString()));
    });
  }

  getUserType() async {
    SharedPreferences? sharedPreferences =
        await SharedPreferences.getInstance();
    userType = sharedPreferences.getString("userType");
  }
}
