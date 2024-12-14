import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'dart:io';

class CameraCaptureWidget extends StatefulWidget {
  final bool multiple; // Whether to allow multiple images
  final Function(List<Uint8List>)? onImageListUpdated; // Callback to listen to images

  const CameraCaptureWidget({
    Key? key,
    this.multiple = false,
    this.onImageListUpdated,
  }) : super(key: key);

  @override
  State<CameraCaptureWidget> createState() => _CameraCaptureWidgetState();
}

class _CameraCaptureWidgetState extends State<CameraCaptureWidget> {
  CameraController? _cameraController;
  List<Uint8List> _images = []; // Store image bytes

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0],
          ResolutionPreset.medium,
        );
        await _cameraController?.initialize();
        setState(() {}); // Update UI once camera is initialized
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print("Camera not initialized.");
      return;
    }

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final Uint8List imageBytes = await File(imageFile.path).readAsBytes();

      setState(() {
        if (widget.multiple) {
          _images.add(imageBytes);
        } else {
          _images = [imageBytes];
        }
      });

      widget.onImageListUpdated?.call(_images);
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _cameraController != null && _cameraController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              )
            : const Text('Loading camera...'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _captureImage,
          child: Text(widget.multiple ? 'Capture Images' : 'Capture Image'),
        ),
        const SizedBox(height: 20),
        _images.isNotEmpty
            ? Wrap(
                children: _images
                    .map((imageBytes) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.memory(
                            imageBytes,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ))
                    .toList(),
              )
            : const Text('No images captured yet.'),
      ],
    );
  }
}
