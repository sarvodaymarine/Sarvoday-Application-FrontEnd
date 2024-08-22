import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkAuthentication() async {
    try {
      emit(AuthLoading());

      // final response =
      //     await http.get(Uri.parse('https://api.example.com/auth/check'));
      //
      // if (response.statusCode == 200) {
      emit(Authenticated());
      // } else {
      //   emit(UnAuthenticated());
      // }
    } catch (e) {
      emit(const AuthError('Failed to authenticate'));
    }
  }
}
