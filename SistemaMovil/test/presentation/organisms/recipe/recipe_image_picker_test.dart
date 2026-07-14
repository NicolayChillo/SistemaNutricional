import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/presentation/atoms/smart_cached_image.dart';
import '../../../../lib/presentation/organisms/recipe/recipe_image_picker.dart';

void main() {
  Widget createWidget({
    String? existingImageUrl,
    VoidCallback? onPickImage,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: RecipeImagePicker(
          existingImageUrl: existingImageUrl,
          onPickImage: onPickImage ?? () {},
        ),
      ),
    );
  }

  group('RecipeImagePicker Widget Tests', () {
    testWidgets(
      'Debe mostrar mensaje cuando no existe imagen',
      (tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.byType(RecipeImagePicker), findsOneWidget);
        expect(
          find.text('Toca para seleccionar imagen'),
          findsOneWidget,
        );
        expect(
          find.byIcon(Icons.add_photo_alternate),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe ejecutar onPickImage al tocar el selector',
      (tester) async {
        bool picked = false;

        await tester.pumpWidget(
          createWidget(
            onPickImage: () {
              picked = true;
            },
          ),
        );

        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        expect(picked, isTrue);
      },
    );

    testWidgets(
      'Debe mostrar SmartCachedImage cuando existe URL',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            existingImageUrl: 'https://example.com/receta.jpg',
          ),
        );

        expect(find.byType(SmartCachedImage), findsOneWidget);

        final image = tester.widget<SmartCachedImage>(
          find.byType(SmartCachedImage),
        );

        expect(
          image.imageUrl,
          'https://example.com/receta.jpg',
        );
        expect(image.fit, BoxFit.cover);
      },
    );

    testWidgets(
      'No debe mostrar placeholder cuando existe URL',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            existingImageUrl: 'https://example.com/receta.jpg',
          ),
        );

        expect(
          find.text('Toca para seleccionar imagen'),
          findsNothing,
        );
        expect(
          find.byIcon(Icons.add_photo_alternate),
          findsNothing,
        );
      },
    );

    testWidgets(
      'URL vacía debe mostrar selector por defecto',
      (tester) async {
        await tester.pumpWidget(
          createWidget(existingImageUrl: ''),
        );

        expect(
          find.text('Toca para seleccionar imagen'),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.add_photo_alternate),
          findsOneWidget,
        );

        expect(find.byType(SmartCachedImage), findsNothing);
      },
    );

    testWidgets(
      'Debe proporcionar widget de error para imagen de red',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            existingImageUrl: 'https://example.com/receta.jpg',
          ),
        );

        final image = tester.widget<SmartCachedImage>(
          find.byType(SmartCachedImage),
        );

        expect(image.errorWidget, isNotNull);
      },
    );
  });
}