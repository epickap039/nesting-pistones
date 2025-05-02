// input_screen.dart con botón para mostrar sobrantes agrupados por grupo y kit
import 'package:flutter/material.dart';
import '../sobrantes.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  double _tubeLength = 6000;
  final List<String> _tubeTypes = ['Telescópico', '2"', '2½"'];
  String _selectedType = 'Telescópico';
  final Map<String, List<double>> _cutsByType = {
    'Telescópico': [],
    '2"': [],
    '2½"': [],
  };

  bool _showSobrantes = false;

  final _cutController = TextEditingController();
  final _qtyController = TextEditingController();

  @override
  void dispose() {
    _cutController.dispose();
    _qtyController.dispose();
    super.dispose();
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
        ...agrupados.entries.map((grupoEntry) {
          final grupo = grupoEntry.key;
          final etiquetas = grupoEntry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grupo: $grupo',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...etiquetas.entries.map((etqEntry) {
                final etiqueta = etqEntry.key;
                final valores = etqEntry.value;
                final lista = valores
                    .map((v) => '${v.toStringAsFixed(0)} mm')
                    .join(', ');
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                  child: Text('• $etiqueta: $lista'),
                );
              }),
              const SizedBox(height: 8),
            ],
          );
        }),
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
            TextField(
              controller: TextEditingController(text: _tubeLength.toString()),
              decoration: const InputDecoration(
                labelText: 'Largo tubo (mm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => _tubeLength = double.tryParse(v) ?? _tubeLength,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Tipo de tubo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items:
                  _tubeTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
              onChanged: (v) => setState(() => _selectedType = v!),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _cutController,
                    decoration: const InputDecoration(
                      labelText: 'Corte (" pulgadas)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _qtyController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
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
                    final cut = double.tryParse(_cutController.text);
                    final qty = int.tryParse(_qtyController.text);
                    if (cut == null || qty == null) return;
                    setState(() {
                      _cutsByType[_selectedType]!.addAll(List.filled(qty, cut));
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
                  ..._cutsByType.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${e.key}: ${e.value.map((c) => c.toStringAsFixed(2)).join(", ")}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }),
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
                      setState(() => sobrantesRepo.vaciar());
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
                        _cutsByType.forEach((_, list) => list.clear());
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
