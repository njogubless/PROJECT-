
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState());

  void toggleTheme(bool isDarkMode) {
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  void setPrimaryColor(Color color) {
    state = state.copyWith(primaryColor: color);
  }
}

// ThemeState class to hold theme data
class ThemeState {
  final bool isDarkMode;
  final Color primaryColor;

  ThemeState({this.isDarkMode = false, this.primaryColor = Colors.blue});

  ThemeData get theme => ThemeData(
    primaryColor: primaryColor,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    useMaterial3: true,
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: isDarkMode ? Colors.grey[900] : primaryColor,
      foregroundColor: isDarkMode ? Colors.white : Colors.white,
    ),
  );

  ThemeState copyWith({
    bool? isDarkMode,
    Color? primaryColor,
  }) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}

// Create a provider for the theme
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});