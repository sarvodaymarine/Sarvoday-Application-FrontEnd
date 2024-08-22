part of 'service_cubit.dart';

sealed class ServiceState extends Equatable {}

final class ServiceInitial extends ServiceState {
  @override
  List<Object?> get props => [];
}

class StateLoading extends ServiceState {
  @override
  List<Object> get props => [];

  @override
  bool? get stringify => null;
}

class StateNoData extends ServiceState {
  @override
  List<Object?> get props => [];
}

class StateErrorGeneral extends ServiceState {
  final String errorMessage;

  StateErrorGeneral(this.errorMessage);

  @override
  List<Object?> get props => [];
}

class StateOnSuccess<T> extends ServiceState {
  final T response;

  StateOnSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class StateOnCrudSuccess<T> extends ServiceState {
  final T response;

  StateOnCrudSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ValidationError extends ServiceState {
  final String errorMessage;

  ValidationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
