part of 'sign_in_cubit.dart';

sealed class SignInState extends Equatable {
  const SignInState();
}

final class SignInInitial extends SignInState {
  @override
  List<Object> get props => [];
}

class Authenticated extends SignInState {
  final bool isFirstTime;

  const Authenticated(this.isFirstTime);

  @override
  List<Object?> get props => [isFirstTime];
}

class Unauthenticated extends SignInState {
  @override
  List<Object?> get props => [];
}

class StateLoading extends SignInState implements Equatable {
  @override
  List<Object> get props => [];

  @override
  bool? get stringify => null;
}

class StateNoData extends SignInState {
  @override
  List<Object?> get props => [];
}

class StateErrorGeneral extends SignInState {
  final String errorMsg;

  const StateErrorGeneral(this.errorMsg);

  @override
  List<Object?> get props => [];
}

class StateOnSuccess<T> extends SignInState {
  final T response;

  const StateOnSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class StateOnSuccess2<T> extends SignInState {
  final T response;

  const StateOnSuccess2(this.response);

  @override
  List<Object?> get props => [response];
}

class ValidationError extends SignInState {
  final String errorMessage;

  const ValidationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
