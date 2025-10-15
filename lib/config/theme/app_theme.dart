import 'package:nubo/config/config.dart';
import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        fontFamily: robotoMedium,
        appBarTheme: const AppBarTheme(centerTitle: false),

        //colors of Brightness.light
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: primary,
          onPrimary: primaryActive,
          secondary: secondary,
          onSecondary: secondaryActive,
          tertiary: tertiary,
          onTertiary: tertiaryActive,
          error: errorColor,
          onError: errorActive,
          surface: background,
          onSurface: Colors.black,
        ),

        // texts: TextTheme
        textTheme: const TextTheme(
          // Black 20
          displayLarge: TextStyle(
            fontFamily: robotoBlack,
            fontSize: 20,
          ),
          // BlackItalic 18
          displayMedium: TextStyle(
            fontFamily: robotoBlackItalic,
            fontSize: 18,
          ),

          // Bold 18
          bodyLarge: TextStyle(
            fontFamily: robotoBold,
            fontSize: 18,
          ),
          // BoldItalic 16
          bodyMedium: TextStyle(
            fontFamily: robotoBoldItalic,
            fontSize: 16,
          ),

          // SemiBold 16
          headlineLarge: TextStyle(
            fontFamily: robotoSemiBold,
            fontSize: 16,
          ),
          // SemiBoldItalic 14
          headlineMedium: TextStyle(
            fontFamily: robotoSemiBoldItalic,
            fontSize: 14,
          ),

          // Medium 14
          titleLarge: TextStyle(
            fontFamily: robotoMedium,
            fontSize: 14,
          ),
          // MediumItalic 12
          titleMedium: TextStyle(
            fontFamily: robotoMediumItalic,
            fontSize: 12,
          ),

          // Regular 13
          titleSmall: TextStyle(
            fontFamily: robotoRegular,
            fontSize: 13,
          ),
          // Italic 12
          labelSmall: TextStyle(
            fontFamily: robotoItalic,
            fontSize: 12,
          ),

          // Light 12
          labelMedium: TextStyle(
            fontFamily: robotoLight,
            fontSize: 12,
          ),
          // LightItalic 11
          labelLarge: TextStyle(
            fontFamily: robotoLightItalic,
            fontSize: 11,
          ),

          // ExtraLight 11
          bodySmall: TextStyle(
            fontFamily: robotoExtraLight,
            fontSize: 11,
          ),
          // ExtraLightItalic 10
          displaySmall: TextStyle(
            fontFamily: robotoExtraLightItalic,
            fontSize: 10,
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: gray400),
        ),
        focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: primary),
        ),
    ) ,
  );
}
