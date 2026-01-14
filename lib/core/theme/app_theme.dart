import 'package:flutter/material.dart';
import 'package:heroic_lsfg_applier/core/theme/steam_deck_constants.dart';

/// App theme configuration with Material 3 design
/// Optimized for Steam Deck touchscreen, trackpad, and gamepad usage
class AppTheme {
  AppTheme._();
  
  // Steam Deck / Gaming inspired colors
  static const _primaryColor = Color(0xFF6366F1); // Indigo
  static const _secondaryColor = Color(0xFF8B5CF6); // Purple
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        secondary: _secondaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 64, // Larger for touch
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: SteamDeckConstants.elementGap),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SteamDeckConstants.cardRadius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, SteamDeckConstants.buttonMinHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SteamDeckConstants.buttonRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, SteamDeckConstants.buttonMinHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SteamDeckConstants.buttonRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(SteamDeckConstants.minTouchTarget, SteamDeckConstants.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(SteamDeckConstants.preferredTouchTarget, SteamDeckConstants.preferredTouchTarget),
          padding: const EdgeInsets.all(12),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.comfortable,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SteamDeckConstants.buttonRadius),
        ),
        filled: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SteamDeckConstants.buttonRadius),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: SteamDeckConstants.navBarHeight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        secondary: _secondaryColor,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E2E),
      ),
      scaffoldBackgroundColor: const Color(0xFF11111B),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 64, // Larger for touch
        backgroundColor: Color(0xFF1E1E2E),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: const Color(0xFF1E1E2E),
        margin: const EdgeInsets.only(bottom: SteamDeckConstants.elementGap),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SteamDeckConstants.cardRadius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, SteamDeckConstants.buttonMinHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SteamDeckConstants.buttonRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, SteamDeckConstants.buttonMinHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SteamDeckConstants.buttonRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(SteamDeckConstants.minTouchTarget, SteamDeckConstants.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(SteamDeckConstants.preferredTouchTarget, SteamDeckConstants.preferredTouchTarget),
          padding: const EdgeInsets.all(12),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.comfortable,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SteamDeckConstants.buttonRadius),
        ),
        filled: true,
        fillColor: const Color(0xFF313244),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SteamDeckConstants.buttonRadius),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: SteamDeckConstants.navBarHeight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: const Color(0xFF1E1E2E),
      ),
    );
  }
}
