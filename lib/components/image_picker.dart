import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageTool extends StatefulWidget {
  const ImageTool({
    this.imagePath,
    this.size = 120,
    this.borderRadius = 24,
    required this.onSave,
    super.key,
  });

  final String? imagePath;
  final void Function(String savaPath) onSave;
  final double? size;
  final double borderRadius;

  @override
  State<ImageTool> createState() => _ImageToolState();
}

class _ImageToolState extends State<ImageTool> {
  final ImagePicker picker = ImagePicker();

  /// 选择图片
  _selectImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final cropImg = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
        maxHeight: 1080,
        maxWidth: 1080,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '裁剪图片',
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
        ],
      );
      if (cropImg != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final filename = basename(cropImg.path);
        final imagePath = '${appDir.path}/$filename';
        await File(imagePath).writeAsBytes(await cropImg.readAsBytes());
        widget.onSave(imagePath);
      }
    }
  }

  _showSelectModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 32,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      _selectImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 32,
                        ),
                        Text(
                          '相机',
                          style: TextStyle(height: 2),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      _selectImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo,
                          size: 32,
                        ),
                        Text(
                          '相册',
                          style: TextStyle(height: 2),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.imagePath == null
          ? IconButton.filledTonal(
              onPressed: () {
                _showSelectModal(context);
              },
              iconSize: widget.size! / 4,
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                )),
              ),
              icon: const Icon(
                Icons.add_a_photo,
              ),
            )
          : InkWell(
              onTap: () {
                _showSelectModal(context);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Image(
                    image: FileImage(
                  File(widget.imagePath ?? ''),
                )),
              ),
            ),
    );
  }
}
