import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  final void Function(String)? onBarcodeDetected;
  final void Function(String)? onPictureTaken;

  const CameraWidget({
    super.key,
    required this.onPictureTaken,
    required this.onBarcodeDetected,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: CameraPreview(_controller),
              ),
              if (widget.onPictureTaken != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        try {
                          final image = await _controller.takePicture();
                          widget.onPictureTaken!(image.path);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ),
            ],
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
