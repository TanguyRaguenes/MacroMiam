import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'camera_widget.dart';

class ChooseImageWidget extends StatefulWidget {
  final void Function(String)? onImageChosen;
  final String? imageUrl;

  const ChooseImageWidget({
    super.key,
    required this.onImageChosen,
    required this.imageUrl,
  });

  @override
  State<ChooseImageWidget> createState() => _ChooseImageWidgetState();
}

class _ChooseImageWidgetState extends State<ChooseImageWidget> {
  bool _isCameraVisible = false;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _isCameraVisible = false;
    _imagePath = null;
  }

  @override
  Widget build(BuildContext context) {
    void toggleIsCameraVisible() {
      setState(() {
        _isCameraVisible = !_isCameraVisible;
      });
    }

    Future<void> selectFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        String path = File(result.files.single.path!).path;
        setState(() {
          _imagePath = path;
        });
        widget.onImageChosen!(path);
      }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                _isCameraVisible ? toggleIsCameraVisible() : null;
                selectFile();
              },
              child: Text('Pick an image'),
            ),
            SizedBox(width: 8),
            Text('OR'),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                toggleIsCameraVisible();
              },
              child: Text('Take a picture'),
            ),
          ],
        ),
        _isCameraVisible
            ? CameraWidget(
              onPictureTaken: (path) {
                setState(() {
                  _imagePath = path;
                });
                widget.onImageChosen!(path);
                toggleIsCameraVisible();
              },
            )
            : Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          _imagePath != null
                              ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                              : widget.imageUrl != null
                              ? Image.network(
                                widget.imageUrl!,
                                fit: BoxFit.cover,
                              )
                              : SvgPicture.asset(
                                'assets/images/No-Image-Placeholder.svg',
                                fit: BoxFit.cover,
                              ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}
