import 'package:flutter/material.dart';
import 'screens/input_screen.dart' as input_scr;
import 'screens/result_screen.dart' as result_scr;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nesting Pistones',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (_) => const input_scr.InputScreen(),
        '/results': (_) => const result_scr.ResultScreen(),
      },
    );
  }
}
