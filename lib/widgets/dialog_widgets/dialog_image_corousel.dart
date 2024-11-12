import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatelessWidget {
  final List<Uint8List> imageBytesList; // List of image byte data

  const ImageCarousel({
    super.key,
    required this.imageBytesList,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: imageBytesList.map((imageBytes) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.memory(
                  imageBytes, // Display image from byte data
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
    );
  }
}
