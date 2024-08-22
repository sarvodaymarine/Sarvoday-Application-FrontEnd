part of 'location_cubit.dart';

sealed class LocationState extends Equatable {}

final class LocationInitial extends LocationState {
  @override
  List<Object?> get props => [];
}

class LocationStateLoading extends LocationState {
  @override
  List<Object> get props => [];

  @override
  bool? get stringify => null;
}

class LocationStateNoData extends LocationState {
  @override
  List<Object?> get props => [];
}

class LocationStateErrorGeneral extends LocationState {
  final String errorMessage;

  LocationStateErrorGeneral(this.errorMessage);

  @override
  List<Object?> get props => [];
}

class LocationStateOnSuccess<T> extends LocationState {
  final T response;

  LocationStateOnSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LocationStateOnCrudSuccess<T> extends LocationState {
  final T response;

  LocationStateOnCrudSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ValidationError extends LocationState {
  final String errorMessage;

  ValidationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
