import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/theme/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    test('Debe definir correctamente la paleta principal', () {
      expect(AppColors.dustGrey, const Color(0xFFDAD7CD));
      expect(AppColors.drySage, const Color(0xFFA3B18A));
      expect(AppColors.fern, const Color(0xFF588157));
      expect(AppColors.hunterGreen, const Color(0xFF3A5A40));
      expect(AppColors.pineTeal, const Color(0xFF344E41));
    });

    test('Debe definir correctamente los colores de estado', () {
      expect(AppColors.error, const Color(0xFFD32F2F));
      expect(AppColors.success, const Color(0xFF388E3C));
      expect(AppColors.warning, const Color(0xFFF57C00));
      expect(AppColors.info, const Color(0xFF1976D2));
    });

    test('Debe definir correctamente los colores de texto', () {
      expect(AppColors.textPrimary, AppColors.pineTeal);
      expect(AppColors.textSecondary, AppColors.hunterGreen);
      expect(AppColors.textLight, AppColors.drySage);
      expect(AppColors.textOnDark, AppColors.dustGrey);
    });

    test('Debe definir correctamente los colores de fondo', () {
      expect(AppColors.background, AppColors.dustGrey);
      expect(AppColors.surface, Colors.white);
      expect(AppColors.surfaceDark, AppColors.pineTeal);
    });

    test('Los colores principales deben ser diferentes entre sí', () {
      final colors = {
        AppColors.dustGrey,
        AppColors.drySage,
        AppColors.fern,
        AppColors.hunterGreen,
        AppColors.pineTeal,
      };

      expect(colors.length, 5);
    });

    test('Los colores de estado deben ser diferentes entre sí', () {
      final colors = {
        AppColors.error,
        AppColors.success,
        AppColors.warning,
        AppColors.info,
      };

      expect(colors.length, 4);
    });
  });
}