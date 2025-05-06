typedef CutEntry = Map<String, dynamic>;

/// kits.dart
///  Formato extendido: cada mapa tiene 4 claves:
///  { grupo, subtipo, largo, cantidad }
///
///  Reglas aplicadas automáticamente
///  ─ Telescópico: 1 corte en Camisa 3½" ⇒ MISMO corte en
///       Tubo Strock, Camisa 2" Al, Barra cromada 1 ½"
///  ─ Pistón 2":   Camisa 2" Al ⇒ +Barra cromada 1 ½"
///  ─ Pistón 2½":  Camisa 2 ½" Al ⇒ +Barra cromada 1 ½"

final Map<String, List<Map<String, dynamic>>> allKits = {
  // ───────────────────────────────────────────────────────── REMOLQUE C3
  'REMOLQUE C3': [
    // Pistón 2"  (c/ réplica en barra)
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Camisa de 2" aluminio',
      'largo': 77,
      'cantidad': 10
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Barra cromada 1 1/2"',
      'largo': 77,
      'cantidad': 10
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Camisa de 2" aluminio',
      'largo': 75,
      'cantidad': 6
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Barra cromada 1 1/2"',
      'largo': 75,
      'cantidad': 6
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Camisa de 2" aluminio',
      'largo': 35,
      'cantidad': 6
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Barra cromada 1 1/2"',
      'largo': 35,
      'cantidad': 6
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Camisa de 2" aluminio',
      'largo': 32,
      'cantidad': 2
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Barra cromada 1 1/2"',
      'largo': 32,
      'cantidad': 2
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Camisa de 2" aluminio',
      'largo': 64,
      'cantidad': 2
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Barra cromada 1 1/2"',
      'largo': 64,
      'cantidad': 2
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Camisa de 2" aluminio',
      'largo': 18,
      'cantidad': 2
    },
    {
      'grupo': 'Pistón Simple de 2"',
      'subtipo': 'Barra cromada 1 1/2"',
      'largo': 18,
      'cantidad': 2
    },

    // Pistón 2½"  (c/ réplica en barra)
    {
      'grupo': 'Pistón Simple de 2 1/2"',
      'subtipo': 'Camisa de 2 1/2" aluminio',
      'largo': 70,
      'cantidad': 2
    },
    {
      'grupo': 'Pistón Simple de 2 1/2"',
      'subtipo': 'Barra cromada 1 1/2"',
      'largo': 70,
      'cantidad': 2
    },

    // Telescópico: cada corte replica en 4 subtipos
    ...[
      {'largo': 48, 'cantidad': 2},
      {'largo': 32, 'cantidad': 2},
      {'largo': 55, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Telescópico',
            'subtipo': 'Camisa de 3 1/2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Telescópico',
            'subtipo': 'Tubo Strock',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Telescópico',
            'subtipo': 'Camisa de 2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Telescópico',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),
  ],

  // ───────────────────────────────────────────────────────── HR C3‑ATR /DX
  'HR C3- ATR /DX (HR CASCADIA/INTERNATIONAL V1)': [
    // Pistón 2"
    ...[
      {'largo': 25, 'cantidad': 4}, // 2+2 (25 twice)
      {'largo': 50, 'cantidad': 4},
      {'largo': 55, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Camisa de 2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),

    // Pistón 2½"
    ...[
      {'largo': 64, 'cantidad': 2},
      {'largo': 50, 'cantidad': 2},
      {'largo': 86, 'cantidad': 2},
      {'largo': 53, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Camisa de 2 1/2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),
  ],

  // ───────────────────────────────────────────────────────── HEAD RAM SCANIA
  'HEAD RAM SCANIA': [
    // Pistón 2"
    ...[
      {'largo': 27, 'cantidad': 2},
      {'largo': 42, 'cantidad': 2},
      {'largo': 14, 'cantidad': 2},
      {'largo': 50, 'cantidad': 8},
      {'largo': 60, 'cantidad': 2},
      {'largo': 20, 'cantidad': 2},
      {'largo': 57, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Camisa de 2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),

    // Pistón 2½"
    {
      'grupo': 'Pistón Simple de 2 1/2"',
      'subtipo': 'Camisa de 2 1/2" aluminio',
      'largo': 50,
      'cantidad': 2
    },
    {
      'grupo': 'Pistón Simple de 2 1/2"',
      'subtipo': 'Barra cromada 1 1/2"',
      'largo': 50,
      'cantidad': 2
    },
  ],

  // ───────────────────────────────────────────────────────── HEAD RAMP TLM
  'HEAD RAMP TLM (HR KENWORTH V1)': [
    // Pistón 2"
    ...[
      {'largo': 25, 'cantidad': 2},
      {'largo': 75, 'cantidad': 4},
      {'largo': 50, 'cantidad': 2},
      {'largo': 28, 'cantidad': 2},
      {'largo': 53, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Camisa de 2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),

    // Pistón 2½"
    ...[
      {'largo': 75, 'cantidad': 4},
      {'largo': 52, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Camisa de 2 1/2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),
  ],

  // ───────────────────────────────────────────────────────── FULL R1 2023
  'FULL R1 2023 (R1 FULL 2024-2025)': [
    // Pistón 2"
    ...[
      {'largo': 54, 'cantidad': 2},
      {'largo': 74, 'cantidad': 2},
      {'largo': 38, 'cantidad': 2},
      {'largo': 34, 'cantidad': 2},
      {'largo': 68, 'cantidad': 2},
      {'largo': 78, 'cantidad': 2},
      {'largo': 29, 'cantidad': 4},
      {'largo': 72, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Camisa de 2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),

    // Pistón 2½"
    ...[
      {'largo': 72, 'cantidad': 2},
      {'largo': 58, 'cantidad': 4},
      {'largo': 42, 'cantidad': 2},
      {'largo': 41, 'cantidad': 1},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Camisa de 2 1/2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),

    // Telescópico
    ...[
      {'largo': 46, 'cantidad': 4},
      {'largo': 52, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Telescópico',
            'subtipo': 'Camisa de 3 1/2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Telescópico',
            'subtipo': 'Tubo Strock',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Telescópico',
            'subtipo': 'Camisa de 2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Telescópico',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),
  ],

  // ───────────────────────────────────────────────────────── FULL R2 2024‑25
  'FULL R2 (FULL R2 2024-2025)': [
    // Pistón 2"
    ...[
      {'largo': 77, 'cantidad': 6},
      {'largo': 38, 'cantidad': 6},
      {'largo': 64, 'cantidad': 2},
      {'largo': 18, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Camisa de 2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),

    // Pistón 2½"
    ...[
      {'largo': 75, 'cantidad': 2},
      {'largo': 68, 'cantidad': 2},
      {'largo': 70, 'cantidad': 1},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Camisa de 2 1/2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),

    // Telescópico
    ...[
      {'largo': 48, 'cantidad': 2},
      {'largo': 55, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Telescópico',
            'subtipo': 'Camisa de 3 1/2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Telescópico',
            'subtipo': 'Tubo Strock',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Telescópico',
            'subtipo': 'Camisa de 2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Telescópico',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),
  ],

  // ───────────────────────────────────────────────────────── HEAD RAMP TRL NISSAN
  'HEAD RAMP TRL/ NISSAN (KENWORTH V2)': [
    // Pistón 2"
    ...[
      {'largo': 25, 'cantidad': 2},
      {'largo': 75, 'cantidad': 4},
      {'largo': 50, 'cantidad': 2},
      {'largo': 28, 'cantidad': 2},
      {'largo': 53, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Camisa de 2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),

    // Pistón 2½"
    ...[
      {'largo': 64, 'cantidad': 2},
      {'largo': 52, 'cantidad': 2},
      {'largo': 75, 'cantidad': 2},
    ].expand((c) => [
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Camisa de 2 1/2" aluminio',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
          {
            'grupo': 'Pistón Simple de 2 1/2"',
            'subtipo': 'Barra cromada 1 1/2"',
            'largo': c['largo'],
            'cantidad': c['cantidad']
          },
        ]),
  ],
};

const Map<String, double> ajustesPorSubtipo = {
  'Camisa de 3 1/2" aluminio': 87,
  'Tubo Strock': 111,
  'Camisa de 2" aluminio': 138,
  'Camisa de 2 1/2" aluminio': 85,
  'Barra cromada 1 1/2"': 179,
};

final List<Map<String, dynamic>> kits = allKits.entries.map((entry) {
  final kitName = entry.key;
  final rawCuts = entry.value;

  final Map<String, Map<String, List<double>>> cortes = {};
  for (var cut in rawCuts) {
    final grupo = cut['grupo'] as String;
    final subtipo = cut['subtipo'] as String;
    final largo = (cut['largo'] as num).toDouble();
    final cantidad = cut['cantidad'] as int;

    cortes.putIfAbsent(grupo, () => {});
    cortes[grupo]!.putIfAbsent(subtipo, () => []);
    cortes[grupo]![subtipo]!.addAll(List.filled(cantidad, largo));
  }

  return {
    'id': kitName,
    'cuts': cortes,
    'ajustes': ajustesPorSubtipo,
  };
}).toList();
