part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();
}

final class SplashInitial extends SplashState {
  @override
  List<Object> get props => [];
}

class AuthInitial extends SplashState {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends SplashState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends SplashState {
  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends SplashState {
  @override
  List<Object?> get props => [];
}

class AuthError extends SplashState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
