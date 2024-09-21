import 'package:auto_route/auto_route.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  NavigationService._internal();

  late StackRouter _router;

  void setRouter(StackRouter router) {
    _router = router;
  }

  StackRouter get router => _router;

  void navigateToLogin() {
    _router.replaceAll([SignInRoute()]);
  }
}
