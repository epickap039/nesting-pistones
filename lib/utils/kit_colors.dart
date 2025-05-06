import 'package:flutter/material.dart';

class KitColors {
  static const Map<String, Color> baseColors = {
    'Remolque C3': Color(0xFFFFF176), // amarillo pastel
    'HR C3- ATR': Color(0xFFD1C4E9), // morado pastel
    'HEAD RAMP SCANIA': Color(0xFFF8BBD0), // rosa pastel
    'HEAD RAMP TLM': Color(0xFFB3E5FC), // azul pastel
    'FULL R1 2023': Color(0xFFFFCC80), // naranja pastel
    'FULL R2': Color(0xFFC8E6C9), // verde claro pastel
    'HEAD RAMP TRL': Color(0xFFD7CCC8), // beis pastel
  };

  static Color getColorForCut(String kitName, int index) {
    final base = baseColors[kitName] ?? Colors.grey;
    final factor = (0.9 - (index % 5) * 0.1).clamp(0.5, 1.0);
    return base.withAlpha((255 * factor).toInt());
  }
}
