part of 'employee_cubit.dart';

sealed class EmployeeState extends Equatable {}

final class EmployeeInitial extends EmployeeState {
  @override
  List<Object?> get props => [];
}

class EmpStateLoading extends EmployeeState {
  @override
  List<Object> get props => [];

  @override
  bool? get stringify => null;
}

class EmpStateNoData extends EmployeeState {
  @override
  List<Object?> get props => [];
}

class EmpStateErrorGeneral extends EmployeeState {
  final String errorMessage;

  EmpStateErrorGeneral(this.errorMessage);

  @override
  List<Object?> get props => [];
}

class EmpStateOnSuccess<T> extends EmployeeState {
  final T response;

  EmpStateOnSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class EmpStateOnSuccess2<T> extends EmployeeState {
  final T response;

  EmpStateOnSuccess2(this.response);

  @override
  List<Object?> get props => [response];
}

class EmpStateOnCrudSuccess<T> extends EmployeeState {
  final T response;

  EmpStateOnCrudSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class EmpValidationError extends EmployeeState {
  final String errorMessage;

  EmpValidationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
