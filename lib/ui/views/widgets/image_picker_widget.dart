import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(XFile image)? onImageSelected;
  final String? imageSource;

  const ImagePickerWidget({
    super.key,
    required this.onImageSelected,
    required this.imageSource,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _imageSource;

  @override
  void initState() {
    super.initState();
    _imageSource = widget.imageSource;
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);

    if (image != null) {
      setState(() => _imageSource = image.path);
      widget.onImageSelected?.call(image);
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a photo"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Choose from gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  bool isNetworkImage(imageSource) {
    final uri = Uri.tryParse(imageSource!);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = constraints.maxWidth;
        return Column(
          children: [
            SizedBox(
              width: maxWidth * 0.95,
              child: ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text("Pick an Image"),
                onPressed: _showImageSourceOptions,
              ),
            ),
            Expanded(
              child: SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      _imageSource != null
                          ? (isNetworkImage(_imageSource)
                              ? Image.network(_imageSource!, fit: BoxFit.cover)
                              : Image.file(
                                File(_imageSource!),
                                fit: BoxFit.cover,
                              ))
                          : Image.asset(
                            'assets/images/no_image.png',
                            fit: BoxFit.cover,
                          ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
