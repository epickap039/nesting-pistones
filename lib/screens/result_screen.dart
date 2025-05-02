import 'package:flutter/material.dart';
import '../bin_packing.dart';
import '../sobrantes.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final cortesTel = List<double>.from(args['cutsTel']);
    final cortes2 = List<double>.from(args['cuts2']);
    final cortes25 = List<double>.from(args['cuts25']);
    final tubeLength = args['tubeLength'] as double;

    // Inicia una nueva iteración en sobrantesRepo
    final iter = DateTime.now().millisecondsSinceEpoch;
    sobrantesRepo.iniciarIteracion(iter);

    Widget buildKit(
      String title,
      List<double> cuts,
      double ajuste,
      String grupo,
    ) {
      if (cuts.isEmpty) return const SizedBox.shrink();

      final validCuts = <double>[];
      final invalidCuts = <double>[];

      for (var pulg in cuts) {
        final mm = pulg * 25.4 - ajuste;
        if (mm <= 0 || mm > tubeLength) {
          invalidCuts.add(pulg);
        } else {
          validCuts.add(pulg);
        }
      }

      if (validCuts.isEmpty && invalidCuts.isEmpty) {
        return const SizedBox.shrink();
      }

      final bins = optimizeCutsConSobrantes(
        validCuts,
        tubeLength,
        ajuste,
        title,
        grupo,
      );

      final uniqueCuts = validCuts.toSet().toList()..sort();
      final colorMap = {
        for (int i = 0; i < uniqueCuts.length; i++)
          uniqueCuts[i]: Colors.primaries[i % Colors.primaries.length],
      };

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (invalidCuts.isNotEmpty) ...[
            const Text(
              "Cortes no válidos:",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: invalidCuts
                  .map((pulg) => Chip(
                        label: Text(
                          '$pulg″ — El corte no puede realizarse en este tubo',
                        ),
                        backgroundColor: Colors.red[100],
                        labelStyle: const TextStyle(color: Colors.red),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
          ...bins.asMap().entries.map((entry) {
            final idx = entry.key;
            final bin = entry.value;
            final used = bin.cortes.fold<double>(0, (s, v) => s + v);
            final pct = (used / tubeLength * 100).toStringAsFixed(1);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tubo ${idx + 1} — Aprovechamiento: $pct%'),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(bin.cortes.length, (i) {
                        final mm = bin.cortes[i];
                        final pulg = (mm + ajuste) / 25.4;
                        final desdeSobrante = bin.desdeSobrante[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Chip(
                            label: Text(
                              desdeSobrante
                                  ? '${pulg.toStringAsFixed(2)}″ | ${mm.toStringAsFixed(0)} mm ♻️'
                                  : '${pulg.toStringAsFixed(2)}″ | ${mm.toStringAsFixed(0)} mm',
                            ),
                            backgroundColor: desdeSobrante
                                ? Colors.grey[400]
                                : colorMap[pulg] ?? Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                      'Desperdicio: ${(tubeLength - used).toStringAsFixed(0)} mm'),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pistón Telescópico',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            buildKit('Camisa de 3 1/2" aluminio', cortesTel, 87, 'Telescópico'),
            buildKit('Tubo Strock', cortesTel, 111, 'Telescópico'),
            buildKit('Camisa de 2" aluminio', cortesTel, 138, 'Telescópico'),
            buildKit('Barra cromada 1 1/2"', cortesTel, 179, 'Telescópico'),
            const Divider(height: 40, thickness: 2),
            const Text(
              'Pistón Simple de 2"',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            buildKit('Camisa de 2" aluminio', cortes2, 85, '2"'),
            buildKit('Barra cromada 1 1/2"', cortes2, 108, '2"'),
            const Divider(height: 40, thickness: 2),
            const Text(
              'Pistón Simple de 2 1/2"',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            buildKit('Camisa de 2 1/2" aluminio', cortes25, 85, '2½"'),
            buildKit('Barra cromada 1 1/2"', cortes25, 108, '2½"'),
          ],
        ),
      ),
    );
  }
}
