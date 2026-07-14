import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/presentation/atoms/circle_icon.dart';
import '../../../../lib/presentation/atoms/title_text.dart';
import '../../../../lib/presentation/organisms/headers/auth_header.dart';

void main() {
  group('AuthHeader Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el título',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AuthHeader(
                title: 'Iniciar sesión',
                icon: Icons.login,
              ),
            ),
          ),
        );

        expect(find.byType(AuthHeader), findsOneWidget);
        expect(find.text('Iniciar sesión'), findsOneWidget);
        expect(find.byType(TitleText), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar correctamente el icono',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AuthHeader(
                title: 'Registro',
                icon: Icons.person_add,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.person_add), findsOneWidget);
        expect(find.byType(CircleIcon), findsOneWidget);
      },
    );

    testWidgets(
      'CircleIcon debe tener tamaño de 100',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AuthHeader(
                title: 'Bienvenido',
                icon: Icons.person,
              ),
            ),
          ),
        );

        final CircleIcon circleIcon = tester.widget<CircleIcon>(
          find.byType(CircleIcon),
        );

        expect(circleIcon.size, 100);
        expect(circleIcon.icon, Icons.person);
      },
    );

    testWidgets(
      'El título debe estar centrado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AuthHeader(
                title: 'Bienvenido',
                icon: Icons.person,
              ),
            ),
          ),
        );

        final TitleText titleText = tester.widget<TitleText>(
          find.byType(TitleText),
        );

        expect(titleText.text, 'Bienvenido');
        expect(titleText.textAlign, TextAlign.center);
      },
    );
  });
}