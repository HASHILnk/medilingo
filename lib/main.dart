import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the new home screen file

void main() {
  runApp(const MediLingoApp());
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
      home: const HomeScreen(),
    );
  }
}