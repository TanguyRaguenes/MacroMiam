import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'camera_widget.dart';

class ChooseImageWidget extends StatefulWidget {
  final void Function(String)? onImageChosen;
  final String? pathOrUrl;

  const ChooseImageWidget({
    super.key,
    required this.onImageChosen,
    required this.pathOrUrl,
  });

  @override
  State<ChooseImageWidget> createState() => _ChooseImageWidgetState();
}

class _ChooseImageWidgetState extends State<ChooseImageWidget> {
  bool _isCameraVisible = false;
  String? _imagePathUrl;

  @override
  void initState() {
    super.initState();
    _isCameraVisible = false;
    _imagePathUrl = widget.pathOrUrl;
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
          _imagePathUrl = path;
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
                FocusManager.instance.primaryFocus?.unfocus();
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
                FocusManager.instance.primaryFocus?.unfocus();
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
                  _imagePathUrl = path;
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
                          _imagePathUrl != null
                              ? _imagePathUrl!.substring(0, 4) == 'http'
                                  ? Image.network(
                                    _imagePathUrl!,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.file(
                                    File(_imagePathUrl!),
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
