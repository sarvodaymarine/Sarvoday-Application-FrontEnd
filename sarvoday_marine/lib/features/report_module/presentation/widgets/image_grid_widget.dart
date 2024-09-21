import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sarvoday_marine/core/theme/sm_text_theme.dart';
import 'package:sarvoday_marine/core/utils/common/common_methods.dart';
import 'package:sarvoday_marine/core/utils/constants/image_path_const.dart';
import 'package:sarvoday_marine/core/utils/widgets/image_picker_service.dart';

class ImageGridWidget extends StatefulWidget {
  final List<Map<String, dynamic>> imageList;
  final String userRole;

  const ImageGridWidget(
      {super.key, required this.imageList, required this.userRole});

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
        final imageFile = imageList[index]['imageFile'];

        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  if (widget.userRole != "client") {
                    XFile? imageFile =
                        await ImagePickerService().imageBottomSheet(context);
                    if (imageFile != null) {
                      setState(() {
                        widget.imageList[index]['imageFile'] = imageFile;
                      });
                    }
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
                    child: (imageFile != null
                        ? CommonMethods.getImageFromLocalPath(imageFile.path)
                        : imageUrl.isNotEmpty
                            ? CommonMethods.getNetworkImage(imageUrl)
                            : Image.asset(ImagePathConst.imageHolder))),
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
