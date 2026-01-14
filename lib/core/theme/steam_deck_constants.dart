import 'package:flutter/material.dart';

/// Constants optimized for Steam Deck touchscreen, trackpad, and gamepad usage
class SteamDeckConstants {
  SteamDeckConstants._();
  
  /// Minimum touch target size for comfortable interaction
  /// Steam Deck screen is 7" at 1280x800, so larger targets are essential
  static const double minTouchTarget = 48.0;
  
  /// Preferred touch target size for primary interactive elements
  static const double preferredTouchTarget = 56.0;
  
  /// Large touch target for important actions
  static const double largeTouchTarget = 64.0;
  
  /// Standard padding for cards and list items
  static const double cardPadding = 16.0;
  
  /// Larger padding for spacious layouts
  static const double spaciousPadding = 24.0;
  
  /// Gap between interactive elements
  static const double elementGap = 12.0;
  
  /// Icon size in cards and lists
  static const double cardIconSize = 64.0;
  
  /// Smaller icon size for secondary elements
  static const double smallIconSize = 24.0;
  
  /// Button minimum height
  static const double buttonMinHeight = 56.0;
  
  /// Navigation bar height
  static const double navBarHeight = 80.0;
  
  /// Focus indicator width
  static const double focusBorderWidth = 3.0;
  
  /// Focus indicator color (high contrast for visibility)
  static const Color focusColor = Color(0xFF6366F1);
  
  /// Card border radius
  static const double cardRadius = 16.0;
  
  /// Button border radius
  static const double buttonRadius = 12.0;
  
  /// Standard button style with Steam Deck-friendly sizing
  static ButtonStyle get primaryButtonStyle => FilledButton.styleFrom(
    minimumSize: const Size(double.infinity, buttonMinHeight),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius),
    ),
  );
  
  /// Outlined button style with Steam Deck-friendly sizing
  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
    minimumSize: const Size(double.infinity, buttonMinHeight),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius),
    ),
  );
  
  /// Icon button style with larger touch target
  static ButtonStyle get iconButtonStyle => IconButton.styleFrom(
    minimumSize: const Size(preferredTouchTarget, preferredTouchTarget),
    padding: const EdgeInsets.all(12),
  );
  
  /// Card decoration with focus support
  static BoxDecoration cardDecoration({
    required BuildContext context,
    bool isFocused = false,
    bool isSelected = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return BoxDecoration(
      color: isSelected 
        ? colorScheme.primaryContainer.withValues(alpha: 0.3)
        : colorScheme.surface,
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(
        color: isFocused 
          ? focusColor 
          : isSelected 
            ? colorScheme.primary.withValues(alpha: 0.5)
            : colorScheme.outline.withValues(alpha: 0.2),
        width: isFocused ? focusBorderWidth : 1.0,
      ),
    );
  }
}
