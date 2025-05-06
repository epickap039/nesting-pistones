import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../state/monthly_plan.dart';
import '../models/kits.dart';

class HomePlannerScreen extends StatelessWidget {
  const HomePlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = context.watch<MonthlyPlan>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificador mensual'),
        actions: [
          IconButton(
            // ← abre InputScreen clásica
            tooltip: 'Entrada manual',
            icon: const Icon(Icons.keyboard),
            onPressed: () => Navigator.pushNamed(context, '/manual'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.playlist_add_check),
        label: const Text('Optimizar'),
        onPressed: () {
          Navigator.pushNamed(context, '/results', arguments: {
            'tubeLength': 6000.0,
            'kits': [plan.buildMonthlyKit()],
          });
        },
      ),
      body: Column(
        children: [
          // ───────── Calendario
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: plan.focusedDay,
            selectedDayPredicate: plan.isSelected,
            onDaySelected: (sel, foc) {
              plan.focusedDay = foc;
              plan.toggleDay(sel); // agrega/quita día
            },
            calendarFormat: CalendarFormat.month,
            eventLoader: plan.kitsDelDia, // pinta puntos en días con kits
          ),
          const Divider(),

          // ───────── Lista de kits (multi‑select) del día enfocado
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Kits para ${plan.focusedDay.day}/${plan.focusedDay.month}/${plan.focusedDay.year}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: allKits.keys.map((kit) {
                final active = plan.kitEnDia(kit);
                return FilterChip(
                  label:
                      Text(kit, maxLines: 1, overflow: TextOverflow.ellipsis),
                  selected: active,
                  onSelected: (_) => plan.toggleKit(kit),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
