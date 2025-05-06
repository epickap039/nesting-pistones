import 'package:flutter/material.dart';
import '../bin_packing.dart';
import '../sobrantes.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  // ────────────────────────────────────────── Construye cada subtipo
  Widget _buildSubtipo(
    String kit,
    String grupo,
    String subtipo,
    List<double> cortesPulg,
    double ajuste,
    double tubeLength,
  ) {
    if (cortesPulg.isEmpty) return const SizedBox.shrink();

    final bins = optimizeCutsConSobrantes(
      cortesPulg,
      tubeLength,
      ajuste,
      subtipo,
      kit,
    );

    final colorBase = Colors.primaries[
        (grupo.hashCode ^ subtipo.hashCode) % Colors.primaries.length];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subtipo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        ...bins.asMap().entries.map((e) {
          final bin = e.value;
          final used = bin.cortes.fold(0.0, (s, v) => s + v);
          final pct = (used / bin.largoReal * 100).toStringAsFixed(1);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Tubo ${e.key + 1}  —  $pct %  (len ${bin.largoReal.toStringAsFixed(0)} mm)'),
                Wrap(
                  spacing: 4,
                  children: List.generate(bin.cortes.length, (i) {
                    final mm = bin.cortes[i];
                    final pulg = (mm + ajuste) / 25.4;
                    return Chip(
                      label: Text(
                          '${pulg.toStringAsFixed(2)}″ | ${mm.toStringAsFixed(0)} mm'
                          '${bin.desdeSobrante[i] ? " ♻️" : ""}'),
                      backgroundColor:
                          bin.desdeSobrante[i] ? Colors.grey : colorBase,
                    );
                  }),
                ),
                Text(
                    'Desperdicio: ${(bin.largoReal - used).toStringAsFixed(0)} mm'),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  // ────────────────────────────────────────── UI Principal
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final kits = List<Map<String, dynamic>>.from(args['kits'] as List);
    final tubeLength = args['tubeLength'] as double;

    sobrantesRepo.iniciarIteracion(DateTime.now().millisecondsSinceEpoch);

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: kits.map((kit) {
          final id = kit['id'] as String;
          final cuts = kit['cuts'] as Map<String, dynamic>;
          final ajustes = Map<String, double>.from(kit['ajustes']);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título del kit
              Text(id,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // ★ NUEVO — recorremos grupos y dibujamos encabezado visualmente
              ...cuts.entries.expand((grupoEntry) {
                final grupo = grupoEntry.key;
                final subtipos = grupoEntry.value as Map<String, dynamic>;

                return [
                  // Encabezado de GRUPO con color sobrio
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    margin: const EdgeInsets.only(top: 8, bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blueGrey.shade200),
                    ),
                    child: Text(
                      grupo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),

                  // Después del encabezado, todos los subtipos de ese grupo
                  ...subtipos.entries.map((e) {
                    final subtipo = e.key;
                    final cortesPulg = List<double>.from(e.value);
                    final ajuste = ajustes[subtipo] ?? 0.0;
                    return _buildSubtipo(
                      id,
                      grupo,
                      subtipo,
                      cortesPulg,
                      ajuste,
                      tubeLength,
                    );
                  }),
                ];
              }),

              const Divider(height: 40, thickness: 2),
            ],
          );
        }).toList(),
      ),
    );
  }
}
