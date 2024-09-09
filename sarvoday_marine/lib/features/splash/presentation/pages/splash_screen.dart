import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/image_path_const.dart';
import 'package:sarvoday_marine/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:sarvoday_marine/features/splash/splash_screen_injection_container.dart';

@RoutePage()
class SplashScreen extends StatefulWidget implements AutoRouteWrapper {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => splashSl<SplashCubit>()),
    ], child: this);
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftToCenterAnimation;
  late Animation<Offset> _centerToRightAnimation;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _leftToCenterAnimation = Tween<Offset>(
      begin: const Offset(-300.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeInOut),
      ),
    );

    _centerToRightAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(300.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        if (isAuthenticated) {
          AutoRouter.of(context).replace(const CalendarRoute());
        } else {
          AutoRouter.of(context).replace(SignInRoute());
        }
      }
    });

    _controller.addListener(() {
      if (_controller.value >= 0.2 && _controller.value < 0.6) {
        context.read<SplashCubit>().checkAuthentication();
      }
    });

    context.read<SplashCubit>().stream.listen((state) {
      if (state is Authenticated) {
        isAuthenticated = true;
      } else if (state is AuthError) {
        if (mounted) {
          CommonMethods.showToast(context, state.message);
        }
      }

      if (_controller.isAnimating || _controller.isCompleted) {
        _controller.forward(from: 0.6);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final animationValue = _controller.value <= 0.3
                ? _leftToCenterAnimation.value
                : _centerToRightAnimation.value;
            return Transform.translate(
              offset: animationValue,
              child: child,
            );
          },
          child: Image.asset(
            ImagePathConst.appLogo,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
