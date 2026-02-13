import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const scaffoldBackgroundColor = Color(0xFFF8F7F7);

class AppTheme {
  ThemeData getTheme() {
    final base = GoogleFonts.montserratAlternates();
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color.fromARGB(255, 255, 255, 255),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: TextTheme(
        titleLarge: base.copyWith(fontSize: 40, fontWeight: FontWeight.bold),
        titleMedium: base.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        titleSmall: base.copyWith(fontSize: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            base.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        titleTextStyle: base.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
