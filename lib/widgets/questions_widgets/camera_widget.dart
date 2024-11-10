import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class CameraCaptureWidget extends StatefulWidget {
  final bool multiple; // Whether to allow multiple images
  final Function(List<Uint8List>)?
      onImageListUpdated; // Callback to listen to images

  const CameraCaptureWidget({
    Key? key,
    this.multiple = false,
    this.onImageListUpdated,
  }) : super(key: key);

  @override
  State<CameraCaptureWidget> createState() => _CameraCaptureWidgetState();
}

class _CameraCaptureWidgetState extends State<CameraCaptureWidget> {
  final ImagePicker _picker = ImagePicker();
  List<Uint8List> _images = []; // Store image bytes

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source:
            ImageSource.gallery, // Use gallery for Flutter Web compatibility
      );

      if (image != null) {
        Uint8List imageBytes = await image.readAsBytes();

        setState(() {
          if (widget.multiple) {
            _images.add(imageBytes); // Add to list for multiple
          } else {
            _images = [imageBytes]; // Only the latest selection
          }
        });

        // Notify listener of the updated image list
        widget.onImageListUpdated?.call(_images);
      }
    } catch (e) {
      print("Error selecting image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImage,
          child: Text(widget.multiple ? 'Select Images' : 'Select Image'),
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
            : const Text('No images selected yet.'),
      ],
    );
  }
}
