import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/constants/image_path_const.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({super.key});

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  int _dots = 1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Timer to update loading text with ellipses
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _dots = (_dots % 3) + 1;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Remove background by setting opacity to 0
        const Opacity(
          opacity: 0.0, // No background overlay
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: Container(
            width: SmTextTheme.getResponsiveSize(context, 120),
            height: SmTextTheme.getResponsiveSize(context, 120),
            decoration: BoxDecoration(
              color: Colors.transparent, // No background color
              borderRadius: BorderRadius.circular(
                SmTextTheme.getResponsiveSize(context, 12),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: ClipPath(
                        clipper: WaveClipper(),
                        // Custom clipper for the wave effect
                        child: Container(
                          width: SmTextTheme.getResponsiveSize(context, 80),
                          height: SmTextTheme.getResponsiveSize(context, 20),
                          color: Colors.blueGrey
                              .withOpacity(0.6), // Darker water effect
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -8 * _animation.value),
                          // Floating effect
                          child: child,
                        );
                      },
                      child: Image.asset(
                        ImagePathConst.appLogo,
                        // Replace with your bot icon path
                        width: SmTextTheme.getResponsiveSize(context, 60),
                        height: SmTextTheme.getResponsiveSize(context, 60),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SmTextTheme.getResponsiveSize(context, 12)),
                RichText(
                  text: TextSpan(
                    text: 'Loading${'.' * _dots}',
                    style: SmTextTheme.labelDescriptionStyle(context).copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = Offset(size.width / 4, size.height - 5);
    var firstEndPoint = Offset(size.width / 2, size.height);
    var secondControlPoint =
        Offset(size.width - (size.width / 4), size.height - 5);
    var secondEndPoint = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Material(
        type: MaterialType.transparency,
        elevation: 0,
        child: SizedBox.expand(child: LoadingDialog()),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
