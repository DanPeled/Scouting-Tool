// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';

class CameraCaptureWidget extends StatefulWidget {
  const CameraCaptureWidget({super.key, this.onImageCaptured});
  final Function(Uint8List image)? onImageCaptured;
  @override
  State<CameraCaptureWidget> createState() => _CameraCaptureWidgetState();
}

class _CameraCaptureWidgetState extends State<CameraCaptureWidget> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  bool _isRearCameraSelected = true;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      controller = CameraController(cameras![0], ResolutionPreset.high);
      await controller!.initialize();
      setState(() {
        isCameraInitialized = true;
      });
    }
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    controller = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future<void> takePicture() async {
    if (!controller!.value.isInitialized) return;
    if (controller!.value.isTakingPicture) return;
    try {
      XFile picture = await controller!.takePicture();
      widget.onImageCaptured!(await picture.readAsBytes());
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: CameraPreview(controller!),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (cameras!.length > 1)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 30,
                icon: Icon(
                  _isRearCameraSelected
                      ? CupertinoIcons.switch_camera
                      : CupertinoIcons.switch_camera_solid,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(
                      () => _isRearCameraSelected = !_isRearCameraSelected);
                  initCamera(cameras![_isRearCameraSelected ? 0 : 1]);
                },
              ),
            IconButton(
              onPressed: takePicture,
              iconSize: 50,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.circle, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
