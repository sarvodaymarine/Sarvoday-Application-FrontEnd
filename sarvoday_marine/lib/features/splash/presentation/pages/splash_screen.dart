import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
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

    // Start checking authentication after a portion of the animation
    _controller.addListener(() {
      if (_controller.value >= 0.2 && _controller.value < 0.4) {
        context.read<SplashCubit>().checkAuthentication();
      }
    });

    // Bloc listener to react to state changes from SplashCubit
    context.read<SplashCubit>().stream.listen((state) {
      _handleAuthenticationState(state);
    });
  }

  void _handleAuthenticationState(SplashState state) {
    if (state is Authenticated) {
      isAuthenticated = true;
      _navigateToHome();
    } else if (state is UnAuthenticated) {
      isAuthenticated = false;
      _navigateToSignIn();
    } else if (state is AuthError) {
      CommonMethods.showToast(context, state.message);
      setState(() {});
    }
  }

  void _navigateToHome() {
    if (mounted) {
      AutoRouter.of(context).replace(const CalendarRoute());
    }
  }

  void _navigateToSignIn() {
    if (mounted) {
      AutoRouter.of(context).replaceAll([SignInRoute()]);
    }
  }

  void _retryAuthentication() {
    context.read<SplashCubit>().checkAuthentication();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SmTextTheme.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return _buildLoadingAnimation();
          } else if (state is AuthError) {
            return _buildErrorUI(state.message);
          } else {
            return _buildLoadingAnimation();
          }
        },
      ),
    );
  }

  // Build animation when loading
  Widget _buildLoadingAnimation() {
    return Center(
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
    );
  }

  Widget _buildErrorUI(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SmTextTheme.getResponsiveSize(context, 16)),
            child: Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _retryAuthentication,
            icon:
                const Icon(Icons.refresh, color: SmCommonColors.secondaryColor),
            label: Text(
              'Retry',
              style: SmTextTheme.infoContentStyle4(context).copyWith(
                  color: SmColorLightTheme.textColor,
                  fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: SmColorLightTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
