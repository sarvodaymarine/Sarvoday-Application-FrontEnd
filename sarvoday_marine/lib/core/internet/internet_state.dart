import 'package:equatable/equatable.dart';
import 'package:sarvoday_marine/core/internet/internet_enum.dart';

sealed class InternetState extends Equatable {
  const InternetState();
}

class StateInternetError extends InternetState {
  @override
  List<Object?> get props => [];
}

class InternetLoading extends InternetState {
  @override
  List<Object> get props => [];
}

class InternetConnected extends InternetState {
  final ConnectionType? connectionType;

  const InternetConnected({required this.connectionType});

  @override
  List<Object?> get props => [connectionType];
}

class InternetDisconnected extends InternetState {
  @override
  List<Object?> get props => [];
}
