part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CMStateLoading extends CalendarState {}

class CMStateNoData extends CalendarState {}

class CMStateLoadingMore extends CalendarState {}

class CMStateError extends CalendarState {
  final String message;

  const CMStateError(this.message);

  @override
  List<Object?> get props => [message];
}

class CMStateOnCrudSuccess<T> extends CalendarState {
  final T response;

  const CMStateOnCrudSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CMStateOnCrudSuccess2<T> extends CalendarState {
  final T response;

  const CMStateOnCrudSuccess2(this.response);

  @override
  List<Object?> get props => [response];
}

class CMStateOnSuccess extends CalendarState {
  final Map<DateTime, List<SalesOrderModel>> response;
  final DateTime selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;

  const CMStateOnSuccess(
    this.response,
    this.selectedDay,
    this.focusedDay,
    this.calendarFormat,
  );

  @override
  List<Object?> get props =>
      [response, selectedDay, focusedDay, calendarFormat];
}

class CMStateUserTypeLoaded extends CalendarState {
  final String userType;

  const CMStateUserTypeLoaded(this.userType);

  @override
  List<Object?> get props => [userType];
}
