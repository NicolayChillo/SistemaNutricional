import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/pages/notification_detail_page.dart';

void main() {
  Widget createTestWidget({
    String title = 'Aviso importante',
    String body = 'Este es un mensaje para toda la comunidad.',
  }) {
    return MaterialApp(
      home: NotificationDetailPage(
        title: title,
        body: body,
      ),
    );
  }

  group('NotificationDetailPage Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el AppBar',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(
          find.text('Mensaje para la comunidad'),
          findsOneWidget,
        );

        expect(find.byType(AppBar), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar correctamente el título recibido',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            title: 'Nueva notificación',
          ),
        );

        expect(
          find.text('Nueva notificación'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar correctamente el cuerpo recibido',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            body: 'Mensaje especial para los usuarios.',
          ),
        );

        expect(
          find.text('Mensaje especial para los usuarios.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar el icono de monitor de salud',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(
          find.byIcon(Icons.monitor_heart),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar el botón Cerrar',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Cerrar'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      },
    );

    testWidgets(
      'Debe contener Scaffold y SafeArea',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Scaffold), findsOneWidget);

        final safeAreas = find.byType(SafeArea);
        expect(safeAreas, findsWidgets);
      },
    );

    testWidgets(
      'Debe cerrar la página al presionar Cerrar',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => Scaffold(
                    body: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const NotificationDetailPage(
                              title: 'Aviso',
                              body: 'Mensaje de prueba',
                            ),
                          ),
                        );
                      },
                      child: const Text('Abrir notificación'),
                    ),
                  ),
            },
          ),
        );

        await tester.tap(find.text('Abrir notificación'));
        await tester.pumpAndSettle();

        expect(
          find.text('Mensaje para la comunidad'),
          findsOneWidget,
        );

        await tester.tap(find.text('Cerrar'));
        await tester.pumpAndSettle();

        expect(
          find.text('Abrir notificación'),
          findsOneWidget,
        );

        expect(
          find.text('Mensaje para la comunidad'),
          findsNothing,
        );
      },
    );
  });
}