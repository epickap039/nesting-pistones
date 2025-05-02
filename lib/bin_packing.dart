// bin_packing.dart con agrupación unificada por kit común
import 'sobrantes.dart';

class ResultadoBin {
  final List<double> cortes;
  final List<bool> desdeSobrante;

  ResultadoBin(this.cortes, this.desdeSobrante);
}

// Función auxiliar para normalizar kits comunes
String grupoUnificado(String etiqueta) {
  final lower = etiqueta.toLowerCase();
  if (lower.contains('camisa de 2"')) return 'Camisa de 2" aluminio';
  if (lower.contains('barra') && lower.contains('1 1/2')) {
    return 'Barra cromada 1 1/2"';
  }

  if (lower.contains('camisa de 3 1/2')) return 'Telescópico';
  if (lower.contains('tub')) return 'Telescópico';
  if (lower.contains('2½')) return '2½"';
  return etiqueta; // por defecto usa la misma etiqueta
}

List<ResultadoBin> optimizeCutsConSobrantes(
  List<double> cutsPulg,
  double tubeLength,
  double adjust,
  String etiquetaKit,
  String grupo,
) {
  final sorted =
      cutsPulg.map((p) => (p * 25.4) - adjust).where((mm) => mm > 0).toList()
        ..sort((a, b) => b.compareTo(a));

  final List<ResultadoBin> resultado = [];
  final List<double> used = [];

  final grupoFinal = grupoUnificado(etiquetaKit);

  for (var cut in sorted) {
    // No usar sobrantes por ahora
    bool placed = false;
    for (int i = 0; i < resultado.length; i++) {
      final bin = resultado[i];
      if (!bin.desdeSobrante.contains(true) && used[i] + cut <= tubeLength) {
        bin.cortes.add(cut);
        bin.desdeSobrante.add(false);
        used[i] += cut;
        placed = true;
        break;
      }
    }

    if (!placed) {
      resultado.add(ResultadoBin([cut], [false]));
      used.add(cut);
    }
  }

  for (int i = 0; i < resultado.length; i++) {
    final bin = resultado[i];
    final isFromSobrante = bin.desdeSobrante.every((e) => e);
    if (isFromSobrante) continue;
    final restante = tubeLength - used[i];
    if (restante > 100) {
      sobrantesRepo.agregar(etiquetaKit, restante, grupoFinal);
    }
  }

  return resultado;
}
