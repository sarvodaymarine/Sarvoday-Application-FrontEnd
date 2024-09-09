part of 'report_cubit.dart';

sealed class ReportState {}

final class ReportInitial extends ReportState {}

class StateLoading extends ReportState implements Equatable {
  @override
  List<Object> get props => [];

  @override
  bool? get stringify => null;
}

class StateNoData extends ReportState {}

class StateErrorGeneral extends ReportState {
  final String errorMsg;

  StateErrorGeneral(this.errorMsg);
}

class StateOnCrudSuccess<T> extends ReportState {
  final T response;

  StateOnCrudSuccess(this.response);
}

class StateOnSuccess2<T> extends ReportState {
  final T response;

  StateOnSuccess2(this.response);
}

class StateOnSuccess<T> extends ReportState {
  final T response;

  StateOnSuccess(this.response);
}

class ValidationError extends ReportState {
  final String errorMessage;

  ValidationError(this.errorMessage);
}
