// lib/models/kit.dart
// Modelo de datos (opcional)
class Kit {
  final String name;
  final double tubeLength;
  final double adjustMM;
  final List<double> cuts;

  Kit({
    required this.name,
    required this.tubeLength,
    required this.adjustMM,
    required this.cuts,
  });
}