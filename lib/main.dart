import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(
    // Wrap your app with the provider
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MediLingoApp(),
    ),
  );
}

class MediLingoApp extends StatelessWidget {
  const MediLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediLingo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
      // Set the HomeScreen as the starting point of the app
      home: const WelcomeScreen(),
    );
  }
}