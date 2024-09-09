import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sarvoday_marine/core/theme/sm_color_theme.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Check and request camera and storage permissions
  Future<bool> _requestPermission(BuildContext context) async {
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;

    if (cameraStatus.isDenied || storageStatus.isDenied) {
      // Request permissions if denied
      cameraStatus = await Permission.camera.request();
      storageStatus = await Permission.storage.request();
    }

    if (cameraStatus.isPermanentlyDenied || storageStatus.isPermanentlyDenied) {
      // Handle permanently denied permissions by showing a dialog to open settings
      _showPermissionDialog(context);
      return false;
    }

    if (cameraStatus.isRestricted || storageStatus.isRestricted) {
      // Handle restricted permissions
      CommonMethods.showToast(
          context, 'Permission is restricted. You cannot access this feature.');
      return false;
    }

    // if (!cameraStatus.isGranted || !storageStatus.isGranted) {
    //   // Handle temporarily denied permissions
    //   CommonMethods.showToast(
    //       context, 'Permission denied. Please grant access.');
    //   return false;
    // }

    // Permissions are granted
    return true;
  }

  // Show dialog to open app settings
  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
            'Permissions are permanently denied. Please enable them in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Pick image from the specified source (camera or gallery)
  Future<String?> _pickImage(BuildContext context, ImageSource source) async {
    final isPermissionGranted = await _requestPermission(context);

    if (!isPermissionGranted) {
      return null;
    }

    // Pick the image from the specified source
    final pickedFile = await _picker.pickImage(source: source);
    return pickedFile?.path; // Return the file path if the image is picked
  }

  // Display a bottom sheet to choose between camera and gallery and return the selected image path
  Future<String?> imageBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(SmTextTheme.getResponsiveSize(context, 14)),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imagePickerOptionsUI(
                context,
                Icons.camera,
                'Pick Image from Camera',
                () async {
                  final imagePath =
                      await _pickImage(context, ImageSource.camera);
                  Navigator.pop(context, imagePath);
                },
              ),
              SizedBox(
                height: SmTextTheme.getResponsiveSize(context, 12),
              ),
              _imagePickerOptionsUI(
                context,
                Icons.photo_library,
                'Pick Image from Gallery',
                () async {
                  final imagePath =
                      await _pickImage(context, ImageSource.gallery);
                  Navigator.pop(context, imagePath);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _imagePickerOptionsUI(BuildContext context, IconData icon, String optionTxt,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SmTextTheme.getResponsiveSize(context, 16),
            vertical: SmTextTheme.getResponsiveSize(context, 8)),
        child: Row(
          children: [
            Icon(
              icon,
              color: SmCommonColors.secondaryColor,
              size: SmTextTheme.getResponsiveSize(context, 16),
            ),
            SizedBox(width: SmTextTheme.getResponsiveSize(context, 12)),
            RichText(
                text: TextSpan(
                    text: optionTxt, style: SmTextTheme.labelStyle3(context))),
          ],
        ),
      ),
    );
  }
}
