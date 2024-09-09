import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/widgets/image_picker_service.dart';

class ImageGridWidget extends StatefulWidget {
  final List<Map<String, dynamic>> imageList;

  const ImageGridWidget({super.key, required this.imageList});

  @override
  ImageGridWidgetState createState() => ImageGridWidgetState();
}

class ImageGridWidgetState extends State<ImageGridWidget> {
  Widget _buildImageGrid(List<Map<String, dynamic>> imageList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 6.0,
      ),
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        final imageUrl = imageList[index]['imageUrl'] ?? '';
        final imagePath = imageList[index]['imagePath'] ?? '';

        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  String imageFilePath =
                      await ImagePickerService().imageBottomSheet(context) ??
                          "";
                  if (imageFilePath.isNotEmpty) {
                    setState(() {
                      widget.imageList[index]['imagePath'] = imageFilePath;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: SmTextTheme.getResponsiveSize(context, 100),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageUrl.isNotEmpty
                      ? CommonMethods.getNetworkImage(imageUrl)
                      : (imagePath.isNotEmpty
                          ? CommonMethods.getImageFromLocalPath(imagePath)
                          : Icon(Icons.image,
                              size: SmTextTheme.getResponsiveSize(
                                  context, 70))), // Default if no image
                ),
              ),
              SizedBox(
                height: SmTextTheme.getResponsiveSize(context, 6),
              ),
              RichText(
                maxLines: 2,
                overflow: TextOverflow.visible,
                text: TextSpan(
                  text: imageList[index]['imageName'] ?? "",
                  style: SmTextTheme.infoContentStyle4(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageGrid(widget.imageList);
  }
}
