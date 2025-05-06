import 'package:flutter/material.dart';
import '../models/kits.dart'; // allKits & ajustesPorSubtipo

class MonthlyPlan with ChangeNotifier {
  DateTime focusedDay = DateTime.now();
  final Map<DateTime, Set<String>> _sel = {}; // día → kits

  // ─ Helper
  DateTime _onlyDay(DateTime d) => DateTime(d.year, d.month, d.day);

  // ─ Calendario
  bool isSelected(DateTime d) => _sel.containsKey(_onlyDay(d));
  void toggleDay(DateTime day) {
    final key = _onlyDay(day);
    if (_sel.containsKey(key)) {
      _sel.remove(key);
    } else {
      _sel[key] = {};
    }
    notifyListeners();

    /// Lista de kits asignados al día dado (para etiquetas en el calendario)
    List<String> kitsDelDia(DateTime day) =>
        _sel[_onlyDay(day)]?.toList() ?? [];

    /// Devuelve el set editable del día enfocado; útil para el chip‑list
    Set<String> kitsDelDiaActual() =>
        _sel.putIfAbsent(_onlyDay(focusedDay), () => {});
  }

  // ─ Kits en día actual
  bool kitEnDia(String kit) =>
      _sel[_onlyDay(focusedDay)]?.contains(kit) ?? false;

  void toggleKit(String kit) {
    final key = _onlyDay(focusedDay);
    _sel.putIfAbsent(key, () => {});
    final set = _sel[key]!;
    if (!set.remove(kit)) set.add(kit);
    notifyListeners();
  }

  /// Devuelve la lista de kits ya asignados a un día (para eventLoader)
  List<String> kitsDelDia(DateTime day) => _sel[_onlyDay(day)]?.toList() ?? [];

  // ─ Genera un único “megakit” con cortes fusionados
  Map<String, dynamic> buildMonthlyKit() {
    final Map<String, Map<String, List<double>>> cortes = {};
    for (final day in _sel.keys) {
      for (final kitName in _sel[day]!) {
        final kit = allKits[kitName]!;
        for (final entry in kit) {
          final g = entry['grupo'] as String;
          final s = entry['subtipo'] as String;
          cortes.putIfAbsent(g, () => {});
          cortes[g]!.putIfAbsent(s, () => []);
          cortes[g]![s]!.addAll(List<double>.filled(
              entry['cantidad'], entry['largo'].toDouble()));
        }
      }
    }
    return {
      'id': 'Plan ${focusedDay.month}/${focusedDay.year}',
      'cuts': cortes,
      'ajustes': ajustesPorSubtipo,
    };
  }
}
