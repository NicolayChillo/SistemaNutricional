import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/smart_cached_image.dart';

void main() {
  group('SmartCachedImage Tests', () {
    group('isLocalPath', () {
      test(
        'Debe reconocer una ruta absoluta como ruta local',
        () {
          expect(
            SmartCachedImage.isLocalPath('/storage/images/producto.jpg'),
            isTrue,
          );
        },
      );

      test(
        'Debe reconocer una ruta file como ruta local',
        () {
          expect(
            SmartCachedImage.isLocalPath('file:///images/producto.jpg'),
            isTrue,
          );
        },
      );

      test(
        'Debe reconocer una ruta de Windows como ruta local',
        () {
          expect(
            SmartCachedImage.isLocalPath(r'C:\images\producto.jpg'),
            isTrue,
          );
        },
      );

      test(
        'No debe reconocer una URL HTTP como ruta local',
        () {
          expect(
            SmartCachedImage.isLocalPath(
              'https://example.com/producto.jpg',
            ),
            isFalse,
          );
        },
      );
    });

    group('isNetworkUrl', () {
      test(
        'Debe reconocer una URL HTTP',
        () {
          expect(
            SmartCachedImage.isNetworkUrl(
              'http://example.com/image.jpg',
            ),
            isTrue,
          );
        },
      );

      test(
        'Debe reconocer una URL HTTPS',
        () {
          expect(
            SmartCachedImage.isNetworkUrl(
              'https://example.com/image.jpg',
            ),
            isTrue,
          );
        },
      );

      test(
        'No debe reconocer una ruta local como URL de red',
        () {
          expect(
            SmartCachedImage.isNetworkUrl(
              r'C:\images\producto.jpg',
            ),
            isFalse,
          );
        },
      );
    });

    group('getImageProvider', () {
      test(
        'Debe retornar CachedNetworkImageProvider para URL de red',
        () {
          final provider = SmartCachedImage.getImageProvider(
            'https://example.com/image.jpg',
          );

          expect(provider, isA<CachedNetworkImageProvider>());
        },
      );

      test(
        'Debe retornar FileImage para una ruta local',
        () {
          final provider = SmartCachedImage.getImageProvider(
            r'C:\images\producto.jpg',
          );

          expect(provider, isA<FileImage>());
        },
      );
    });

    group('Widget Tests', () {
      testWidgets(
        'Debe crear CachedNetworkImage para URL HTTPS',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SmartCachedImage(
                  imageUrl: 'https://example.com/image.jpg',
                  width: 200,
                  height: 100,
                ),
              ),
            ),
          );

          expect(find.byType(SmartCachedImage), findsOneWidget);
          expect(find.byType(CachedNetworkImage), findsOneWidget);
        },
      );

      testWidgets(
        'Debe mostrar errorWidget para archivo local inexistente',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SmartCachedImage(
                  imageUrl: 'C:\\archivo_que_no_existe\\imagen.jpg',
                ),
              ),
            ),
          );

          expect(find.byIcon(Icons.broken_image), findsOneWidget);
        },
      );

      testWidgets(
        'Debe utilizar errorWidget personalizado para archivo inexistente',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SmartCachedImage(
                  imageUrl: 'C:\\archivo_que_no_existe\\imagen.jpg',
                  errorWidget: Text('Error personalizado'),
                ),
              ),
            ),
          );

          expect(
            find.text('Error personalizado'),
            findsOneWidget,
          );

          expect(
            find.byIcon(Icons.broken_image),
            findsNothing,
          );
        },
      );

      testWidgets(
        'Debe respetar ancho, alto y fit configurados',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SmartCachedImage(
                  imageUrl: 'https://example.com/image.jpg',
                  width: 250,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );

          final CachedNetworkImage image =
              tester.widget<CachedNetworkImage>(
            find.byType(CachedNetworkImage),
          );

          expect(image.width, 250);
          expect(image.height, 150);
          expect(image.fit, BoxFit.contain);
        },
      );
    });
  });
}