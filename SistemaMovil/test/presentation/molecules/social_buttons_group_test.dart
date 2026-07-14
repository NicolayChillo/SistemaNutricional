import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/social_button.dart';
import '../../../lib/presentation/molecules/social_buttons_group.dart';

void main() {
  group('SocialButtonsGroup Widget Tests', () {
    testWidgets(
      'Debe mostrar botones de Google y Facebook',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SocialButtonsGroup(),
            ),
          ),
        );

        expect(find.byType(SocialButtonsGroup), findsOneWidget);
        expect(find.byType(SocialButton), findsNWidgets(2));
        expect(find.text('Google'), findsOneWidget);
        expect(find.text('Facebook'), findsOneWidget);
        expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
        expect(find.byIcon(Icons.facebook), findsOneWidget);
      },
    );

    testWidgets(
      'Debe ejecutar callback de Google',
      (WidgetTester tester) async {
        bool googlePressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SocialButtonsGroup(
                onGooglePressed: () {
                  googlePressed = true;
                },
              ),
            ),
          ),
        );

        final googleButton = find.widgetWithText(
          SocialButton,
          'Google',
        );

        await tester.tap(googleButton);
        await tester.pump();

        expect(googlePressed, isTrue);
      },
    );

    testWidgets(
      'Debe ejecutar callback de Facebook',
      (WidgetTester tester) async {
        bool facebookPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SocialButtonsGroup(
                onFacebookPressed: () {
                  facebookPressed = true;
                },
              ),
            ),
          ),
        );

        final facebookButton = find.widgetWithText(
          SocialButton,
          'Facebook',
        );

        await tester.tap(facebookButton);
        await tester.pump();

        expect(facebookPressed, isTrue);
      },
    );

    testWidgets(
      'Facebook debe utilizar su color personalizado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SocialButtonsGroup(),
            ),
          ),
        );

        final SocialButton facebookButton =
            tester.widget<SocialButton>(
          find.widgetWithText(SocialButton, 'Facebook'),
        );

        expect(
          facebookButton.foregroundColor,
          const Color(0xFF1877F2),
        );
      },
    );
  });
}