// sobrantes.dart completo con soporte por grupo y actualización
class SobrantesRepository {
  final Map<String, List<double>> _sobrantesPorEtiqueta = {};
  final Map<String, String> _grupoPorEtiqueta = {};

  void agregar(String etiqueta, double valor, [String? grupo]) {
    if (!_sobrantesPorEtiqueta.containsKey(etiqueta)) {
      _sobrantesPorEtiqueta[etiqueta] = [];
      if (grupo != null) {
        _grupoPorEtiqueta[etiqueta] = grupo;
      }
    }
    _sobrantesPorEtiqueta[etiqueta]!.add(valor);
  }

  void eliminarSobrante(String etiqueta, double valor) {
    _sobrantesPorEtiqueta[etiqueta]?.remove(valor);
  }

  double? calcularDesde(String etiqueta, double corte) {
    final disponibles = _sobrantesPorEtiqueta[etiqueta];
    if (disponibles == null) return null;
    disponibles.sort();
    for (final sobrante in disponibles) {
      if (sobrante >= corte) return sobrante;
    }
    return null;
  }

  bool esDeSobrante(String etiqueta, double mm) {
    return _sobrantesPorEtiqueta[etiqueta]?.contains(mm) ?? false;
  }

  void vaciar() {
    _sobrantesPorEtiqueta.clear();
    _grupoPorEtiqueta.clear();
  }

  bool todosVacios() {
    return _sobrantesPorEtiqueta.values.every((list) => list.isEmpty);
  }

  List<String> get etiquetas => _sobrantesPorEtiqueta.keys.toList();

  List<double> obtener(String etiqueta) =>
      _sobrantesPorEtiqueta[etiqueta] ?? [];

  Map<String, List<double>> todosAgrupadosPorEtiqueta() =>
      _sobrantesPorEtiqueta;

  /// Agrupado por grupo -> etiquetas -> sobrantes
  Map<String, Map<String, List<double>>> agrupadosPorGrupo() {
    final Map<String, Map<String, List<double>>> resultado = {};
    for (final entry in _sobrantesPorEtiqueta.entries) {
      final etiqueta = entry.key;
      final grupo = _grupoPorEtiqueta[etiqueta] ?? 'Sin grupo';
      resultado.putIfAbsent(grupo, () => {});
      resultado[grupo]![etiqueta] = entry.value;
    }
    return resultado;
  }

  /// Visualización organizada por grupo y etiqueta
  String imprimirSobrantesAgrupados() {
    final buffer = StringBuffer();
    final agrupados = agrupadosPorGrupo();
    for (final grupo in agrupados.keys) {
      buffer.writeln('Grupo: $grupo');
      final etiquetas = agrupados[grupo]!;
      for (final etiqueta in etiquetas.keys) {
        final valores = etiquetas[etiqueta]!;
        final lista = valores
            .map((v) => '${v.toStringAsFixed(0)} mm')
            .join(', ');
        buffer.writeln('  $etiqueta: $lista');
      }
      buffer.writeln('');
    }
    return buffer.toString();
  }
}

// ✅ Declaración final global
final sobrantesRepo = SobrantesRepository();
