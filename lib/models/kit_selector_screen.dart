import 'package:flutter/material.dart';
import '../screens/result_screen.dart';

class KitSelectorScreen extends StatefulWidget {
  const KitSelectorScreen({super.key});

  @override
  State<KitSelectorScreen> createState() => _KitSelectorScreenState();
}

class _KitSelectorScreenState extends State<KitSelectorScreen> {
  String? selectedKit;

  final List<String> kits = [
    'FULL R1',
    'KENWORTH',
    'CASCADIA',
    'REMOLQUE C3',
    'FULL R2',
    'SCANIA',
  ];

  final Map<String, Map<String, dynamic>> kitData = {
    'FULL R1': {
      'cutsTel': [54, 74, 38],
      'cuts2': [34, 68],
      'cuts25': [78, 29],
      'tubeLength': 6000.0,
    },
    'KENWORTH': {
      'cutsTel': [72, 29, 72],
      'cuts2': [58, 58],
      'cuts25': [42, 41],
      'tubeLength': 6000.0,
    },
    // Agrega los demás kits aquí
  };

  void navigateToResults() {
    if (selectedKit != null && kitData.containsKey(selectedKit)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultScreen(),
          settings: RouteSettings(
            arguments: kitData[selectedKit],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Kit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Selecciona un kit',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.list_alt),
              ),
              value: selectedKit,
              items: kits.map((kit) {
                return DropdownMenuItem<String>(
                  value: kit,
                  child: Text(kit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKit = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: navigateToResults,
              child: const Text('Ver resultados'),
            ),
          ],
        ),
      ),
    );
  }
}
