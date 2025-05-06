import '../sobrantes.dart';

class ResultadoBin {
  final List<double> cortes;
  final List<bool> desdeSobrante;
  final List<double?> origenSobrante;
  final double largoReal;

  ResultadoBin(
    this.cortes,
    this.desdeSobrante,
    this.origenSobrante,
    this.largoReal,
  );
}

String grupoUnificado(String etiqueta) {
  final lower = etiqueta.toLowerCase();
  if (lower.contains('camisa de 2"')) return 'Camisa de 2" aluminio';
  if (lower.contains('barra') && lower.contains('1 1/2')) {
    return 'Barra cromada 1 1/2"';
  }
  if (lower.contains('camisa de 3 1/2')) return 'Camisa de 3 1/2" aluminio';
  if (lower.contains('tub')) return 'Tubo Strock';
  if (lower.contains('2½')) return 'Camisa de 2 1/2" aluminio';
  return etiqueta;
}

List<ResultadoBin> optimizeCutsConSobrantes(
  List<double> cutsPulg,
  double tubeLength,
  double adjust,
  String etiquetaKit,
  String grupo,
) {
  // 1) Prepara lista de cortes en mm
  final sorted = cutsPulg
      .map((p) => (p * 25.4) - adjust)
      .where((mm) => mm > 0)
      .toList()
    ..sort((a, b) => b.compareTo(a));

  final grupoFinal = grupoUnificado(grupo);
  final resultado = <ResultadoBin>[];

  for (var cut in sorted) {
    bool placed = false;

    // 2) Primero: intentar usar un sobrante existente
    final sobrante = sobrantesRepo.calcularDesde(etiquetaKit, cut);
    if (sobrante != null) {
      resultado.add(ResultadoBin(
        [cut], // cortes
        [true], // desdeSobrante
        [sobrante], // origenSobrante
        sobrante, // largoReal
      ));
      sobrantesRepo.eliminarSobrante(etiquetaKit, sobrante, grupoFinal);
      placed = true;
    }

    // 3) Si no vino de sobrante, intentar en cualquier bin (sobrante o nuevo)
    if (!placed) {
      for (var bin in resultado) {
        final used = bin.cortes.fold(0.0, (a, b) => a + b);
        // Usamos bin.largoReal, no tubeLength, para capacidad
        if (used + cut <= bin.largoReal) {
          bin.cortes.add(cut);
          bin.desdeSobrante.add(false);
          bin.origenSobrante.add(null);
          placed = true;
          break;
        }
      }
    }

    // 4) Si aún no se colocó, abrir un tubo nuevo de tamaño tubeLength
    if (!placed) {
      resultado.add(ResultadoBin(
        [cut],
        [false],
        [null],
        tubeLength,
      ));
    }
  }

  // 5) Registrar sobrantes solo de tubos realmente abiertos
  for (var bin in resultado) {
    // Si largoReal == tubeLength ➞ tubo nuevo
    if (bin.largoReal == tubeLength) {
      final used = bin.cortes.fold(0.0, (a, b) => a + b);
      final restante = tubeLength - used;
      if (restante > 0) {
        sobrantesRepo.agregar(etiquetaKit, restante, grupoFinal);
      }
    }
  }

  return resultado;
}
