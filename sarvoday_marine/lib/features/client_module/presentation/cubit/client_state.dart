part of 'client_cubit.dart';

sealed class ClientState extends Equatable {}

final class ClientInitial extends ClientState {
  @override
  List<Object?> get props => [];
}

class CStateLoading extends ClientState {
  @override
  List<Object> get props => [];

  @override
  bool? get stringify => null;
}

class CStateNoData extends ClientState {
  @override
  List<Object?> get props => [];
}

class CStateErrorGeneral extends ClientState {
  final String errorMessage;

  CStateErrorGeneral(this.errorMessage);

  @override
  List<Object?> get props => [];
}

class CStateOnSuccess<T> extends ClientState {
  final T response;

  CStateOnSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CStateOnSuccess2<T> extends ClientState {
  final T response;

  CStateOnSuccess2(this.response);

  @override
  List<Object?> get props => [response];
}

class CStateOnCrudSuccess<T> extends ClientState {
  final T response;

  CStateOnCrudSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CSValidationError extends ClientState {
  final String errorMessage;

  CSValidationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
