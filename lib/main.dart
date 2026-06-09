import 'package:flutter/material.dart';
import 'screens/liste_menages_screen.dart';
import 'screens/detail_menage_screen.dart';
import 'screens/formulaire_menage_screen.dart';
import 'screens/a_propos_screen.dart';

void main() {
  runApp(const BourseApp());
}

class BourseApp extends StatelessWidget {
  const BourseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bourse Sécurité Familiale',
      debugShowCheckedModeBanner: false,

      // Thème personnalisé — design Stitch ODD 1 (Pas de pauvreté)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF0D631B),
          onPrimary: Colors.white,
          primaryContainer: Color(0xFF2E7D32),
          onPrimaryContainer: Color(0xFFCBFFC2),
          secondary: Color(0xFF3C6842),
          onSecondary: Colors.white,
          secondaryContainer: Color(0xFFBDEFBE),
          onSecondaryContainer: Color(0xFF426E47),
          tertiary: Color(0xFF4D5950),
          onTertiary: Colors.white,
          tertiaryContainer: Color(0xFF657167),
          onTertiaryContainer: Color(0xFFE8F5E9),
          error: Color(0xFFBA1A1A),
          onError: Colors.white,
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF93000A),
          surface: Color(0xFFF5FCED),
          onSurface: Color(0xFF171D14),
          surfaceContainerHighest: Color(0xFFDEE5D6),
          outline: Color(0xFF707A6C),
          outlineVariant: Color(0xFFBFCABA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5FCED),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D631B),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFBFCABA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFBFCABA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0D631B), width: 1.5),
          ),
          labelStyle: const TextStyle(color: Color(0xFF40493D), fontSize: 11),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D631B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFFBFCABA).withValues(alpha: 0.4),
            ),
          ),
        ),
      ),

      // Routes nommées — navigation entre les 4 écrans
      initialRoute: '/',
      routes: {
        '/': (_) => const ListeMenagesScreen(),
        '/detail': (_) => const DetailMenageScreen(),
        '/formulaire': (_) => const FormulaireMenageScreen(),
        '/apropos': (_) => const AProposScreen(),
      },
    );
  }
}
