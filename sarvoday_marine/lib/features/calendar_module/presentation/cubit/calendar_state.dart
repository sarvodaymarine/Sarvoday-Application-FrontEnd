part of 'calendar_cubit.dart';

@immutable
sealed class CalendarState extends Equatable {
  const CalendarState();
}

final class CMCalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}

class CMAuthenticated extends CalendarState {
  @override
  List<Object?> get props => [];
}

class CMUnauthenticated extends CalendarState {
  @override
  List<Object?> get props => [];
}

class CMStateLoading extends CalendarState implements Equatable {
  @override
  List<Object> get props => [];

  @override
  bool? get stringify => null;
}

class CMStateNoData extends CalendarState {
  @override
  List<Object?> get props => [];
}

class CMStateErrorGeneral extends CalendarState {
  final String errorMsg;

  const CMStateErrorGeneral(this.errorMsg);

  @override
  List<Object?> get props => [];
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

class CMStateOnSuccess<T> extends CalendarState {
  final T response;

  const CMStateOnSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CMValidationError extends CalendarState {
  final String errorMessage;

  const CMValidationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
