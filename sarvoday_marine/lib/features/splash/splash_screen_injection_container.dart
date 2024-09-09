import 'package:get_it/get_it.dart';
import 'package:sarvoday_marine/features/splash/presentation/cubit/splash_cubit.dart';

GetIt splashSl = GetIt.instance;

Future<void> init() async {
  splashSl.registerFactory(() => SplashCubit());
}
