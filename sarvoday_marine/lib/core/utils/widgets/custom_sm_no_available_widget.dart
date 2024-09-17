import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';

class NoItemsAvailable extends StatelessWidget {
  final String message;

  const NoItemsAvailable({super.key, this.message = "No items available"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_rounded,
            size: SmTextTheme.getResponsiveSize(context, 100),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16.0),
          Text(
            message,
            style: SmTextTheme.infoContentStyle(context),
          ),
        ],
      ),
    );
  }
}
