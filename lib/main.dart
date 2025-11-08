// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase once
  runApp(const EcoTechRepairApp());
}


class EcoTechRepairApp extends StatelessWidget {
  const EcoTechRepairApp({super.key});


  @override
  Widget build(BuildContext context) {
    const Color primaryEcoGreen = Color(0xFF00796B);
    const Color secondaryTeal = Color(0xFF009688);
    const Color backgroundLight = Color(0xFFF5F5F5);


    return MaterialApp(
      title: 'EcoTech Repair Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto', // Clean, readable font


        // Core color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryEcoGreen,
          primary: primaryEcoGreen,
          secondary: secondaryTeal,
          background: backgroundLight,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Colors.black87,
        ),


        scaffoldBackgroundColor: backgroundLight,


        appBarTheme: const AppBarTheme(
          backgroundColor: primaryEcoGreen,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),


        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryEcoGreen, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),


        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            elevation: 4,
            shadowColor: primaryEcoGreen.withOpacity(0.4),
          ),
        ),


        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.w900),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 15, height: 1.4),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
