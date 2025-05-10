import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:macromiam/data/services/image_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CameraWidget extends StatefulWidget {
  final void Function(XFile)? onPictureTaken;

  const CameraWidget({super.key, required this.onPictureTaken});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late final CameraController _controller;
  late final Future<void> _initializeControllerFuture;

  Future<void> setupCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final CameraDescription camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.medium);
    return await _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = setupCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ImageService saveImageService = context.read<ImageService>();
    final ScaffoldMessengerState scaffoldMessengerState = ScaffoldMessenger.of(
      context,
    );
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Expanded(
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CameraPreview(_controller),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        try {
                          final XFile cacheImage =
                              await _controller.takePicture();
                          widget.onPictureTaken?.call(cacheImage);
                        } catch (e) {
                          scaffoldMessengerState.showSnackBar(
                            SnackBar(
                              content: Text(
                                "Not enough space available or camera error",
                              ),
                            ),
                          );
                        }
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
