// sobrantes.dart con soporte de sobrantes por iteración, grupo y etiqueta

class SobrantesRepository {
  int _currentIteration = 0;

  /// Estructura: iteración -> grupo -> etiqueta -> lista de sobrantes
  final Map<int, Map<String, Map<String, List<double>>>> _data = {};

  /// Inicia una nueva iteración para agrupar sobrantes
  void iniciarIteracion(int iter) {
    _currentIteration = iter;
    _data[iter] = {};
  }

  /// Agrega un sobrante (en mm) bajo la [etiqueta] y [grupo] en la iteración actual
  void agregar(String etiqueta, double valor, String grupo) {
    final iterMap = _data[_currentIteration]!;
    final groupMap = iterMap.putIfAbsent(grupo, () => {});
    final list = groupMap.putIfAbsent(etiqueta, () => []);
    list.add(valor);
  }

  /// Elimina un sobrante específico de la iteración actual
  void eliminarSobrante(String etiqueta, double valor, String grupo) {
    final iterMap = _data[_currentIteration];
    if (iterMap == null) return;
    iterMap[grupo]?[etiqueta]?.remove(valor);
  }

  /// Busca el sobrante mínimo >= [corte] en la iteración actual
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

  /// Verifica si [mm] proviene de un sobrante en la iteración actual
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

  /// Limpia todos los sobrantes de todas las iteraciones
  void vaciar() {
    _data.clear();
    _currentIteration = 0;
  }

  /// Verifica si en la iteración dada (o actual) no hay sobrantes
  bool todosVacios({int? iter}) {
    final key = iter ?? _currentIteration;
    final iterMap = _data[key];
    if (iterMap == null) return true;
    return iterMap.values
        .every((groupMap) => groupMap.values.every((list) => list.isEmpty));
  }

  /// Obtiene el map de sobrantes agrupados por grupo y etiqueta para una iteración
  Map<String, Map<String, List<double>>> agrupadosPorGrupo({int? iter}) {
    return _data[iter ?? _currentIteration] ?? {};
  }

  /// Devuelve todos los sobrantes organizados por iteración, grupo y etiqueta
  Map<int, Map<String, Map<String, List<double>>>> agrupadosPorIteracion() {
    return _data;
  }

  /// Imprime sobrantes de la iteración actual en formato texto
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

  /// Imprime todos los sobrantes organizados por iteración
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

// Instancia global
final sobrantesRepo = SobrantesRepository();
