// input_screen.dart actualizado para usar los kits de kit_selector_screen.dart

import 'package:flutter/material.dart';
import '../sobrantes.dart';
import '../models/kits.dart'; // ya está incluida, pero asegúrate de que el path sea correcto
// Importamos los kits formales

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  double _tubeLength = 6000;
  final List<String> _tubeTypes = ['Telescópico', '2"', '2½"'];
  String _selectedType = 'Telescópico';
  String? _kitSeleccionado;
  final Map<String, List<double>> _cutsByType = {
    'Telescópico': [],
    '2"': [],
    '2½"': [],
  };

  bool _showSobrantes = false;

  final TextEditingController _cutController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  @override
  void dispose() {
    _cutController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  void cargarCortesDesdeKit(String nombreKit) {
    final kit = allKits[nombreKit]!;

    final cortesTel = <double>[];
    final cortes2 = <double>[];
    final cortes25 = <double>[];

    for (var entrada in kit) {
      final tipo = entrada['tipo'] as String;
      final largo = entrada['largo'] as double;
      final cantidad = entrada['cantidad'] as int;

      List<double> lista;
      if (tipo == 'Telescópico') {
        lista = cortesTel;
      } else if (tipo == '2"') {
        lista = cortes2;
      } else if (tipo == '2½"') {
        lista = cortes25;
      } else {
        throw Exception('Tipo desconocido: $tipo');
      }

      for (int i = 0; i < cantidad; i++) {
        lista.add(largo);
      }
    }

    Navigator.pushNamed(
      context,
      '/results',
      arguments: {
        'cutsTel': cortesTel,
        'cuts2': cortes2,
        'cuts25': cortes25,
        'tubeLength': _tubeLength,
      },
    );
  }

  Widget buildSobrantesAgrupados() {
    if (!_showSobrantes) return const SizedBox.shrink();

    final agrupados = sobrantesRepo.agrupadosPorGrupo();
    if (agrupados.isEmpty) return const Text('No hay sobrantes');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text(
          'Sobrantes por grupo y kit',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final grupoEntry in agrupados.entries) ...[
          Text(
            'Grupo: ${grupoEntry.key}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          for (final etiquetaEntry in grupoEntry.value.entries) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
              child: Text(
                '• ${etiquetaEntry.key}: ${etiquetaEntry.value.map((v) => '${v.toStringAsFixed(0)} mm').join(', ')}',
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Definir Kit'), centerTitle: true),
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
              onChanged: (String? v) {
                setState(() => _kitSeleccionado = v);
                if (v != null) cargarCortesDesdeKit(v);
              },
              items: allKits.keys
                  .map((String k) => DropdownMenuItem<String>(
                        value: k,
                        child: Text(k),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Largo tubo (mm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              controller: TextEditingController(text: _tubeLength.toString()),
              keyboardType: TextInputType.number,
              onChanged: (String v) {
                _tubeLength = double.tryParse(v) ?? _tubeLength;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tipo de tubo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              value: _selectedType,
              onChanged: (String? v) => setState(() => _selectedType = v!),
              items: _tubeTypes
                  .map(
                      (t) => DropdownMenuItem<String>(value: t, child: Text(t)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Corte (" pulgadas)',
                      border: OutlineInputBorder(),
                    ),
                    controller: _cutController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                  ),
                  onPressed: () {
                    final double? cut = double.tryParse(_cutController.text);
                    final int? qty = int.tryParse(_qtyController.text);
                    if (cut == null || qty == null) return;
                    setState(() {
                      _cutsByType[_selectedType]!
                          .addAll(List<double>.filled(qty, cut));
                    });
                    _cutController.clear();
                    _qtyController.clear();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  for (final entry in _cutsByType.entries) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${entry.key}: ${entry.value.map((c) => c.toStringAsFixed(2)).join(', ')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                  buildSobrantesAgrupados(),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Optimizar Todo'),
                    onPressed: () {
                      sobrantesRepo.vaciar();
                      Navigator.pushNamed(
                        context,
                        '/results',
                        arguments: {
                          'cutsTel': _cutsByType['Telescópico']!,
                          'cuts2': _cutsByType['2"']!,
                          'cuts25': _cutsByType['2½"']!,
                          'tubeLength': _tubeLength,
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.undo),
                    label: const Text('Deshacer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        final list = _cutsByType[_selectedType]!;
                        if (list.isNotEmpty) list.removeLast();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text('Limpiar Todo'),
                    onPressed: () {
                      setState(() {
                        for (final key in _cutsByType.keys) {
                          _cutsByType[key]!.clear();
                        }
                        sobrantesRepo.vaciar();
                        _showSobrantes = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => setState(() => _showSobrantes = !_showSobrantes),
              child: Text(
                _showSobrantes ? 'Ocultar sobrantes' : 'Mostrar sobrantes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
