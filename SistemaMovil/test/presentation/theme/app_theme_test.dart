import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/theme/app_colors.dart';
import '../../../lib/presentation/theme/app_theme.dart';

void main() {
  late ThemeData theme;

  setUp(() {
    theme = AppTheme.lightTheme;
  });

  group('AppTheme LightTheme Tests', () {
    test('Debe utilizar Material 3', () {
      expect(theme.useMaterial3, isTrue);
    });

    test('Debe configurar correctamente el ColorScheme', () {
      expect(theme.colorScheme.primary, AppColors.hunterGreen);
      expect(theme.colorScheme.secondary, AppColors.fern);
      expect(theme.colorScheme.tertiary, AppColors.drySage);
      expect(theme.colorScheme.surface, AppColors.surface);
      expect(theme.colorScheme.error, AppColors.error);
      expect(theme.colorScheme.onPrimary, Colors.white);
      expect(theme.colorScheme.onSecondary, Colors.white);
      expect(theme.colorScheme.onSurface, AppColors.textPrimary);
      expect(theme.colorScheme.onError, Colors.white);
    });

    test('Debe configurar correctamente el fondo del Scaffold', () {
      expect(
        theme.scaffoldBackgroundColor,
        AppColors.background,
      );
    });

    test('Debe configurar correctamente el AppBarTheme', () {
      final appBarTheme = theme.appBarTheme;

      expect(
        appBarTheme.backgroundColor,
        AppColors.hunterGreen,
      );
      expect(appBarTheme.foregroundColor, Colors.white);
      expect(appBarTheme.elevation, 0);
      expect(appBarTheme.centerTitle, isTrue);
    });

    test('Debe configurar correctamente InputDecorationTheme', () {
      final inputTheme = theme.inputDecorationTheme;

      expect(inputTheme.filled, isTrue);
      expect(inputTheme.fillColor, Colors.white);
      expect(
        inputTheme.contentPadding,
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      );
    });

    test('El borde normal debe tener radio 12 y color drySage', () {
      final border = theme.inputDecorationTheme.border;

      expect(border, isA<OutlineInputBorder>());

      final outlineBorder = border as OutlineInputBorder;

      expect(
        outlineBorder.borderRadius,
        BorderRadius.circular(12),
      );
      expect(
        outlineBorder.borderSide.color,
        AppColors.drySage,
      );
    });

    test('El borde habilitado debe usar drySage', () {
      final border = theme.inputDecorationTheme.enabledBorder;

      expect(border, isA<OutlineInputBorder>());

      final outlineBorder = border as OutlineInputBorder;

      expect(
        outlineBorder.borderSide.color,
        AppColors.drySage,
      );
    });

    test('El borde enfocado debe usar fern y ancho 2', () {
      final border = theme.inputDecorationTheme.focusedBorder;

      expect(border, isA<OutlineInputBorder>());

      final outlineBorder = border as OutlineInputBorder;

      expect(
        outlineBorder.borderSide.color,
        AppColors.fern,
      );
      expect(outlineBorder.borderSide.width, 2);
    });

    test('El borde de error debe utilizar AppColors.error', () {
      final border = theme.inputDecorationTheme.errorBorder;

      expect(border, isA<OutlineInputBorder>());

      final outlineBorder = border as OutlineInputBorder;

      expect(
        outlineBorder.borderSide.color,
        AppColors.error,
      );
    });

    test('El borde de error enfocado debe tener ancho 2', () {
      final border =
          theme.inputDecorationTheme.focusedErrorBorder;

      expect(border, isA<OutlineInputBorder>());

      final outlineBorder = border as OutlineInputBorder;

      expect(
        outlineBorder.borderSide.color,
        AppColors.error,
      );
      expect(outlineBorder.borderSide.width, 2);
    });

    test('Debe configurar correctamente ElevatedButtonTheme', () {
      final style = theme.elevatedButtonTheme.style;

      expect(style, isNotNull);

      expect(
        style!.backgroundColor?.resolve({}),
        AppColors.hunterGreen,
      );

      expect(
        style.foregroundColor?.resolve({}),
        Colors.white,
      );

      expect(
        style.padding?.resolve({}),
        const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      );

      expect(style.elevation?.resolve({}), 2);
    });

    test('ElevatedButton debe tener radio de borde 12', () {
      final style = theme.elevatedButtonTheme.style!;

      final shape = style.shape?.resolve({});

      expect(shape, isA<RoundedRectangleBorder>());

      final roundedShape = shape as RoundedRectangleBorder;

      expect(
        roundedShape.borderRadius,
        BorderRadius.circular(12),
      );
    });

    test('Debe configurar correctamente OutlinedButtonTheme', () {
      final style = theme.outlinedButtonTheme.style;

      expect(style, isNotNull);

      expect(
        style!.foregroundColor?.resolve({}),
        AppColors.hunterGreen,
      );

      expect(
        style.padding?.resolve({}),
        const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      );

      expect(
        style.side?.resolve({})?.color,
        AppColors.hunterGreen,
      );
    });

    test('OutlinedButton debe tener radio de borde 12', () {
      final style = theme.outlinedButtonTheme.style!;

      final shape = style.shape?.resolve({});

      expect(shape, isA<RoundedRectangleBorder>());

      final roundedShape = shape as RoundedRectangleBorder;

      expect(
        roundedShape.borderRadius,
        BorderRadius.circular(12),
      );
    });

    test('Debe configurar correctamente TextButtonTheme', () {
      final style = theme.textButtonTheme.style;

      expect(style, isNotNull);

      expect(
        style!.foregroundColor?.resolve({}),
        AppColors.fern,
      );

      expect(
        style.padding?.resolve({}),
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      );
    });

    test('Debe configurar correctamente displayLarge', () {
      final style = theme.textTheme.displayLarge;

      expect(style, isNotNull);
      expect(style!.fontSize, 32);
      expect(style.fontWeight, FontWeight.bold);
      expect(style.color, AppColors.textPrimary);
    });

    test('Debe configurar correctamente displayMedium', () {
      final style = theme.textTheme.displayMedium;

      expect(style, isNotNull);
      expect(style!.fontSize, 28);
      expect(style.fontWeight, FontWeight.bold);
      expect(style.color, AppColors.textPrimary);
    });

    test('Debe configurar correctamente displaySmall', () {
      final style = theme.textTheme.displaySmall;

      expect(style, isNotNull);
      expect(style!.fontSize, 24);
      expect(style.fontWeight, FontWeight.bold);
      expect(style.color, AppColors.textPrimary);
    });

    test('Debe configurar correctamente headlineMedium', () {
      final style = theme.textTheme.headlineMedium;

      expect(style, isNotNull);
      expect(style!.fontSize, 20);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.color, AppColors.textPrimary);
    });

    test('Debe configurar correctamente headlineSmall', () {
      final style = theme.textTheme.headlineSmall;

      expect(style, isNotNull);
      expect(style!.fontSize, 18);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.color, AppColors.textPrimary);
    });

    test('Debe configurar correctamente titleLarge', () {
      final style = theme.textTheme.titleLarge;

      expect(style, isNotNull);
      expect(style!.fontSize, 16);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.color, AppColors.textPrimary);
    });

    test('Debe configurar correctamente bodyLarge', () {
      final style = theme.textTheme.bodyLarge;

      expect(style, isNotNull);
      expect(style!.fontSize, 16);
      expect(style.color, AppColors.textSecondary);
    });

    test('Debe configurar correctamente bodyMedium', () {
      final style = theme.textTheme.bodyMedium;

      expect(style, isNotNull);
      expect(style!.fontSize, 14);
      expect(style.color, AppColors.textSecondary);
    });

    test('Debe configurar correctamente bodySmall', () {
      final style = theme.textTheme.bodySmall;

      expect(style, isNotNull);
      expect(style!.fontSize, 12);
      expect(style.color, AppColors.textLight);
    });
  });
}