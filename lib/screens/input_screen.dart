import 'package:flutter/material.dart';
import '../sobrantes.dart';
import '../models/kits.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  double _tubeLength = 6000;
  String? _kitSeleccionado;

  final List<String> _grupos = [
    'Telescópico',
    'Pistón Simple de 2"',
    'Pistón Simple de 2 1/2"',
  ];

  final Map<String, List<String>> _subtiposPorGrupo = {
    'Telescópico': [
      'Camisa de 3 1/2" aluminio',
      'Tubo Strock',
      'Camisa de 2" aluminio',
      'Barra cromada 1 1/2"'
    ],
    'Pistón Simple de 2"': ['Camisa de 2" aluminio', 'Barra cromada 1 1/2"'],
    'Pistón Simple de 2 1/2"': [
      'Camisa de 2 1/2" aluminio',
      'Barra cromada 1 1/2"'
    ],
  };

  String _grupoSeleccionado = 'Telescópico';
  String _subtipoSeleccionado = 'Camisa de 3 1/2" aluminio';

  final Map<String, Map<String, List<double>>> _cutsByType = {
    'Telescópico': {
      'Camisa de 3 1/2" aluminio': [],
      'Tubo Strock': [],
      'Camisa de 2" aluminio': [],
      'Barra cromada 1 1/2"': [],
    },
    'Pistón Simple de 2"': {
      'Camisa de 2" aluminio': [],
      'Barra cromada 1 1/2"': [],
    },
    'Pistón Simple de 2 1/2"': {
      'Camisa de 2 1/2" aluminio': [],
      'Barra cromada 1 1/2"': [],
    },
  };

  final TextEditingController _cutController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  @override
  void dispose() {
    _cutController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  // Carga un kit predefinido y navega a resultados sin mezclar con manuales
  void cargarCortesDesdeKit(String nombreKit) {
    final kitBase = kits.firstWhere((k) => k['id'] == nombreKit);
    final Map<String, Map<String, List<double>>> cortesConvertidos = {};
    final rawCuts = kitBase['cuts'] as Map<String, dynamic>;

    rawCuts.forEach((grupo, subtipos) {
      cortesConvertidos[grupo] = {};
      (subtipos as Map<String, dynamic>).forEach((subtipo, lista) {
        cortesConvertidos[grupo]![subtipo] = List<double>.from(lista);
      });
    });

    final ajustes = <String, double>{};
    (kitBase['ajustes'] as Map<String, dynamic>)
        .forEach((k, v) => ajustes[k] = (v as num).toDouble());

    final kit = {
      'id': nombreKit,
      'cuts': cortesConvertidos,
      'ajustes': ajustes
    };

    sobrantesRepo.vaciar();
    Navigator.pushNamed(context, '/results', arguments: {
      'tubeLength': _tubeLength,
      'kits': [kit],
    });
  }

  // Optimiza cortes manuales actuales
  void optimizarCortesManuales() {
    final cortes = _cutsByType.map((grupo, subtipos) => MapEntry(grupo,
        subtipos.map((sub, lista) => MapEntry(sub, List<double>.from(lista)))));

    final kitManual = {
      'id': 'Cortes Manuales',
      'cuts': cortes,
      'ajustes': ajustesPorSubtipo,
    };

    sobrantesRepo.vaciar();
    Navigator.pushNamed(context, '/results', arguments: {
      'tubeLength': _tubeLength,
      'kits': [kitManual],
    });
  }

  Widget buildListaCortes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _cutsByType.entries.expand((grupoEntry) {
        final grupo = grupoEntry.key;
        return grupoEntry.value.entries.map((subEntry) {
          final subtipo = subEntry.key;
          final lista = subEntry.value;
          if (lista.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '$grupo → $subtipo: '
              '${lista.map((c) => c.toStringAsFixed(0)).join(', ')}',
              style: const TextStyle(fontSize: 16),
            ),
          );
        });
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Nesting de Pistones'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Kit predefinido',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.list_alt),
              ),
              value: _kitSeleccionado,
              onChanged: (v) => cargarCortesDesdeKit(v!),
              items: kits
                  .map((k) => k['id'] as String)
                  .map((id) => DropdownMenuItem(value: id, child: Text(id)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Largo del tubo (mm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              controller: TextEditingController(text: _tubeLength.toString()),
              keyboardType: TextInputType.number,
              onChanged: (v) => _tubeLength = double.tryParse(v) ?? _tubeLength,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Grupo de tubo',
                border: OutlineInputBorder(),
              ),
              value: _grupoSeleccionado,
              onChanged: (v) {
                setState(() {
                  _grupoSeleccionado = v!;
                  _subtipoSeleccionado = _subtiposPorGrupo[v]!.first;
                });
              },
              items: _grupos
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Subtipo de tubo',
                border: OutlineInputBorder(),
              ),
              value: _subtipoSeleccionado,
              onChanged: (v) => setState(() => _subtipoSeleccionado = v!),
              items: _subtiposPorGrupo[_grupoSeleccionado]!
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cutController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Corte (" pulgadas)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final cut = double.tryParse(_cutController.text);
                    final qty = int.tryParse(_qtyController.text);
                    if (cut == null || qty == null) return;
                    setState(() {
                      _cutsByType[_grupoSeleccionado]?[_subtipoSeleccionado]
                          ?.addAll(List<double>.filled(qty, cut));
                    });
                    _cutController.clear();
                    _qtyController.clear();
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: ListView(children: [buildListaCortes()])),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: optimizarCortesManuales,
                    child: const Text('Optimizar Todo'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final lista = _cutsByType[_grupoSeleccionado]
                            ?[_subtipoSeleccionado];
                        if (lista != null && lista.isNotEmpty) {
                          lista.removeLast();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child: const Text('Deshacer'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        for (var grupo in _cutsByType.values) {
                          for (var lista in grupo.values) {
                            lista.clear();
                          }
                        }
                        sobrantesRepo.vaciar();
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Limpiar Todo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
