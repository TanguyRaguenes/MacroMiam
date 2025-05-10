import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macromiam/data/repositories/aliment_repository.dart';
import 'package:macromiam/data/services/file_picker_service.dart';
import 'package:provider/provider.dart';

import 'camera_widget.dart';

class ChooseImageWidget extends StatefulWidget {
  final void Function(XFile)? onImageChosen;
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
    final FilePickerService filePickerService =
        context.read<FilePickerService>();
    final ScaffoldMessengerState scaffoldMessengerState = ScaffoldMessenger.of(
      context,
    );

    final AlimentRepository alimentRepository =
        context.read<AlimentRepository>();
    void toggleIsCameraVisible() {
      setState(() {
        _isCameraVisible = !_isCameraVisible;
      });
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //###FILE PICKER###
            ElevatedButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                _isCameraVisible ? toggleIsCameraVisible() : null;
                final String? previousImagePath = _imagePathUrl;
                try {
                  await filePickerService.selectFile(
                    onFilePicked: (cacheImage) async {
                      setState(() {
                        _imagePathUrl = cacheImage.path;
                      });
                      widget.onImageChosen?.call(cacheImage);
                    },
                  );
                } catch (e) {
                  scaffoldMessengerState.showSnackBar(
                    SnackBar(content: Text('Error : $e')),
                  );
                }
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
        // ###CAMERA###
        _isCameraVisible
            ? CameraWidget(
              onPictureTaken: (cacheImage) {
                setState(() {
                  _imagePathUrl = cacheImage.path;
                });
                widget.onImageChosen?.call(cacheImage);
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
                                'assets/images/no_image_placeholder.svg',
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
