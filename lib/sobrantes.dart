class SobrantesRepository {
  int _currentIteration = 0;

  /// Estructura: iteración -> tipo base -> subtipo -> lista de sobrantes
  final Map<int, Map<String, Map<String, List<double>>>> _data = {};

  /// Mapa que define a qué tipo base pertenece un subtipo
  final Map<String, String> subtipoToTipoBase = {
    'Camisa de 3 1/2" aluminio': '3_1/2',
    'Tubo Strock': 'Strock',
    'Camisa de 2" aluminio': '2"',
    'Camisa de 2 1/2" aluminio': '2½"',
    'Barra cromada 1 1/2"': 'Barra',
  };

  void iniciarIteracion(int iter) {
    _currentIteration = iter;
    _data[iter] = {};
  }

  void agregar(String subtipo, double valor, String grupo) {
    final tipoBase = subtipoToTipoBase[subtipo] ?? subtipo;
    final iterMap = _data[_currentIteration]!;
    final tipoMap = iterMap.putIfAbsent(tipoBase, () => {});
    final list = tipoMap.putIfAbsent(subtipo, () => []);
    list.add(valor);
  }

  void eliminarSobrante(String subtipo, double valor, String grupo) {
    final tipoBase = subtipoToTipoBase[subtipo] ?? subtipo;
    final iterMap = _data[_currentIteration];
    if (iterMap == null) return;
    iterMap[tipoBase]?[subtipo]?.remove(valor);
  }

  double? calcularDesde(String subtipo, double corte, {String? grupo}) {
    final tipoBase = subtipoToTipoBase[subtipo] ?? subtipo;
    final iterMap = _data[_currentIteration];
    if (iterMap == null) return null;
    final tipoMap = iterMap[tipoBase];
    if (tipoMap == null) return null;

    for (final lista in tipoMap.values) {
      lista.sort();
      for (final sobrante in lista) {
        if (sobrante >= corte) return sobrante;
      }
    }

    return null;
  }

  bool esDeSobrante(String subtipo, double mm, {String? grupo}) {
    final tipoBase = subtipoToTipoBase[subtipo] ?? subtipo;
    final iterMap = _data[_currentIteration];
    if (iterMap == null) return false;

    final tipoMap = iterMap[tipoBase];
    if (tipoMap == null) return false;

    for (final lista in tipoMap.values) {
      if (lista.contains(mm)) return true;
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
        .every((tipoMap) => tipoMap.values.every((list) => list.isEmpty));
  }

  Map<String, Map<String, List<double>>> agrupadosPorGrupo({int? iter}) {
    final iterMap = _data[iter ?? _currentIteration];
    if (iterMap == null) return {};
    return iterMap;
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

    agrupados.forEach((tipoBase, subtipos) {
      buffer.writeln('Tipo base: $tipoBase');
      subtipos.forEach((subtipo, valores) {
        final lista =
            valores.map((v) => '${v.toStringAsFixed(0)} mm').join(', ');
        buffer.writeln('  $subtipo: $lista');
      });
      buffer.writeln();
    });
    return buffer.toString();
  }

  String imprimirPorIteracion() {
    final buffer = StringBuffer();
    if (_data.isEmpty) return 'No hay iteraciones con sobrantes';
    _data.forEach((iter, tipoMap) {
      buffer.writeln('--- Iteración $iter ---');
      tipoMap.forEach((tipoBase, subtipos) {
        buffer.writeln('Tipo base: $tipoBase');
        subtipos.forEach((subtipo, valores) {
          final lista =
              valores.map((v) => '${v.toStringAsFixed(0)} mm').join(', ');
          buffer.writeln('  $subtipo: $lista');
        });
        buffer.writeln();
      });
      buffer.writeln();
    });
    return buffer.toString();
  }
}

final sobrantesRepo = SobrantesRepository();
