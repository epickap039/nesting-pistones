import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

// Pantallas
import 'screens/home_planner_screen.dart' as planner_scr;
import 'screens/input_screen.dart' as input_scr;
import 'screens/result_screen.dart' as result_scr;

// Provider de estado
import 'state/monthly_plan.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ───── Firebase (si falla, la app sigue funcionando)
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase inicializado correctamente');
  } catch (e) {
    debugPrint('Error al inicializar Firebase: $e');
  }

  // ───── Hive (para planes mensuales; quita si no lo usas aún)
  await Hive.initFlutter();
  await Hive.openBox('plans');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MonthlyPlan()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nesting Pistones',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
        ),
        // Ruta inicial: calendario de planificación
        initialRoute: '/planner',
        routes: {
          '/planner': (_) => const planner_scr.HomePlannerScreen(),
          '/manual': (_) => const input_scr.InputScreen(), // pantalla clásica
          '/results': (_) => const result_scr.ResultScreen(),
        },
      ),
    );
  }
}
