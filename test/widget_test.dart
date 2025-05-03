// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nestingpistones_pruebas/main.dart';

void main() {
  testWidgets('App muestra pantalla de Definir Kit', (
    WidgetTester tester,
  ) async {
    // Carga la app
    await tester.pumpWidget(MyApp());
    // Verifica el título de la AppBar
    expect(find.text('Nesting Pistones'), findsOneWidget);
  });
}
