// sobrantes.dart con soporte de sobrantes por iteración, grupo y etiqueta (agrupando etiquetas iguales entre grupos)

class SobrantesRepository {
  int _currentIteration = 0;

  /// Estructura: iteración -> grupo -> etiqueta -> lista de sobrantes
  final Map<int, Map<String, Map<String, List<double>>>> _data = {};

  void iniciarIteracion(int iter) {
    _currentIteration = iter;
    _data[iter] = {};
  }

  void agregar(String etiqueta, double valor, String grupo) {
    final iterMap = _data[_currentIteration]!;
    final groupMap = iterMap.putIfAbsent(grupo, () => {});
    final list = groupMap.putIfAbsent(etiqueta, () => []);
    list.add(valor);
  }

  void eliminarSobrante(String etiqueta, double valor, String grupo) {
    final iterMap = _data[_currentIteration];
    if (iterMap == null) return;
    iterMap[grupo]?[etiqueta]?.remove(valor);
  }

  double? calcularDesde(String etiqueta, double corte, {String? grupo}) {
    final iterMap = _data[_currentIteration];
    if (iterMap == null) return null;

    List<double>? disponibles;
    if (grupo != null) {
      disponibles = iterMap[grupo]?[etiqueta];
    } else {
      for (final groupMap in iterMap.values) {
        if (groupMap.containsKey(etiqueta)) {
          disponibles = groupMap[etiqueta];
          break;
        }
      }
    }
    if (disponibles == null) return null;

    disponibles.sort();
    for (final sobrante in disponibles) {
      if (sobrante >= corte) return sobrante;
    }
    return null;
  }

  bool esDeSobrante(String etiqueta, double mm, {String? grupo}) {
    final iterMap = _data[_currentIteration];
    if (iterMap == null) return false;
    if (grupo != null) {
      return iterMap[grupo]?[etiqueta]?.contains(mm) ?? false;
    }
    for (final groupMap in iterMap.values) {
      if (groupMap[etiqueta]?.contains(mm) ?? false) return true;
    }
    return false;
  }

  void vaciar() {
    _data.clear();
    _currentIteration = 0;
  }

  bool todosVacios({int? iter}) {
    final key = iter ?? _currentIteration;
    final iterMap = _data[key];
    if (iterMap == null) return true;
    return iterMap.values
        .every((groupMap) => groupMap.values.every((list) => list.isEmpty));
  }

  /// NUEVO: agrupación por etiqueta ignorando grupo (etiquetas iguales se agrupan juntas)
  Map<String, Map<String, List<double>>> agrupadosPorGrupo({int? iter}) {
    final Map<String, List<double>> etiquetasUnificadas = {};
    final iterMap = _data[iter ?? _currentIteration];
    if (iterMap == null) return {};

    for (final groupMap in iterMap.values) {
      for (final entry in groupMap.entries) {
        etiquetasUnificadas.putIfAbsent(entry.key, () => []);
        etiquetasUnificadas[entry.key]!.addAll(entry.value);
      }
    }

    return {
      'Agrupado': etiquetasUnificadas,
    };
  }

  Map<int, Map<String, Map<String, List<double>>>> agrupadosPorIteracion() {
    return _data;
  }

  String imprimirSobrantes() {
    final buffer = StringBuffer();
    final agrupados = agrupadosPorGrupo();
    if (agrupados.isEmpty) {
      return 'No hay sobrantes en iteración $_currentIteration';
    }

    agrupados.forEach((grupo, etiquetas) {
      buffer.writeln('Grupo: $grupo');
      etiquetas.forEach((etiqueta, valores) {
        final lista =
            valores.map((v) => '${v.toStringAsFixed(0)} mm').join(', ');
        buffer.writeln('  $etiqueta: $lista');
      });
      buffer.writeln();
    });
    return buffer.toString();
  }

  String imprimirPorIteracion() {
    final buffer = StringBuffer();
    if (_data.isEmpty) return 'No hay iteraciones con sobrantes';
    _data.forEach((iter, grupos) {
      buffer.writeln('--- Iteración $iter ---');
      grupos.forEach((grupo, etiquetas) {
        buffer.writeln('Grupo: $grupo');
        etiquetas.forEach((etiqueta, valores) {
          final lista =
              valores.map((v) => '${v.toStringAsFixed(0)} mm').join(', ');
          buffer.writeln('  $etiqueta: $lista');
        });
        buffer.writeln();
      });
      buffer.writeln();
    });
    return buffer.toString();
  }
}

final sobrantesRepo = SobrantesRepository();
