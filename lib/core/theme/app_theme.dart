import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Color _primaryGreen = Color(0xFF00E676);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);

  // Dark Theme (Default)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryGreen,
        secondary: _primaryGreen,
        surface: _darkSurface,
        error: Color(0xFFCF6679),
        onPrimary: Colors.black,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: _darkBackground,
      cardTheme: CardThemeData(
        color: _darkSurface.withValues(alpha: 0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: Colors.white70,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF00C853),
        secondary: const Color(0xFF00C853),
        surface: Colors.grey.shade50,
        error: const Color(0xFFB00020),
        onPrimary: Colors.white,
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.black87,
      ),
      iconTheme: const IconThemeData(color: Colors.black54),
    );
  }

  // Cyberpunk Theme
  static ThemeData get cyberpunkTheme {
    const Color neonPink = Color(0xFFFF0080);
    const Color neonCyan = Color(0xFF00FFFF);
    const Color darkPurple = Color(0xFF0A0A1E);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: neonPink,
        secondary: neonCyan,
        surface: Color(0xFF1A1A2E),
        error: neonPink,
        onPrimary: Colors.white,
        onSurface: neonCyan,
      ),
      scaffoldBackgroundColor: darkPurple,
      cardTheme: CardThemeData(
        color: const Color(0xFF16213E).withValues(alpha: 0.9),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: neonCyan, width: 1.5),
        ),
      ),
      textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: neonCyan,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkPurple,
        elevation: 0,
        centerTitle: false,
      ),
      iconTheme: const IconThemeData(color: neonCyan),
    );
  }

  // Ocean Theme
  static ThemeData get oceanTheme {
    const Color oceanBlue = Color(0xFF0077BE);
    const Color seafoam = Color(0xFF40E0D0);
    const Color deepOcean = Color(0xFF001F3F);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: seafoam,
        secondary: oceanBlue,
        surface: Color(0xFF003459),
        error: Color(0xFFFF6B6B),
        onPrimary: deepOcean,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: deepOcean,
      cardTheme: CardThemeData(
        color: const Color(0xFF003459).withValues(alpha: 0.85),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: seafoam, width: 1),
        ),
      ),
      textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: Colors.white70,
        displayColor: seafoam,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: deepOcean,
        elevation: 0,
        centerTitle: false,
      ),
      iconTheme: const IconThemeData(color: seafoam),
    );
  }
}
