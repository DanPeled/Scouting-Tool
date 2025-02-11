// Flutter imports:
import 'package:flutter/material.dart';

class GlobalIcons {
  static const Icon nextPageIcon = Icon(Icons.arrow_forward_ios_outlined);
}

class GlobalColors {
  static Color primaryColor = Colors.black;
  static const Color teamColor = Color(0xffff66c4);
  static const Color appBarColor = Colors.black;
  static Color get backgroundColor {
    if (primaryColor == Colors.white) return primaryColor;
    return const Color.fromRGBO(30, 30, 30, 255);
  }

  static Color get backButtonColor {
    return Colors.white;
  }
}

extension ColorInverter on Color {
  Color invert() {
    return Color.fromRGBO(255 - red, 255 - green, 255 - blue, opacity);
  }
}

Color getColorByPrecentile(double score, double pageAvg) {
  double precentage = score / pageAvg;
  if (precentage <= 0.25) {
    return Colors.redAccent.shade400;
  } else if (precentage <= 0.75) {
    return Colors.white70;
  } else if (precentage <= 0.9) {
    return Colors.redAccent.shade100;
  } else if (precentage < 0.99) {
    return Colors.greenAccent.shade400;
  } else {
    return Colors.blueAccent.shade100;
  }
}
