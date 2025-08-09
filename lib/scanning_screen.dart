import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'results_screen.dart'; // <-- We will create this next

class ScanningScreen extends StatefulWidget {
  final String imagePath;
  const ScanningScreen({super.key, required this.imagePath});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  @override
  void initState() {
    super.initState();
    // Start the upload process as soon as the screen loads
    _uploadAndAnalyze(widget.imagePath);
  }

  Future<void> _uploadAndAnalyze(String imagePath) async {
    final dio = Dio();
    final file = File(imagePath);
    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    try {
      // Use 10.0.2.2 for the Android emulator to connect to your local PC
      final response = await dio.post('http://192.168.16.243:8000/api/analyze/', data: formData);

      if (response.statusCode == 200 && mounted) {
        // The backend sends the JSON as a string, so we need to decode it
        final analysisData = jsonDecode(response.data);

        // Success! Navigate to ResultsScreen and pass the decoded data
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResultsScreen(data: analysisData)),
        );
      } else {
        // Handle server-side error
        if (mounted) _showError('Failed to get analysis from server.');
      }
    } catch (e) {
      // Handle network or other errors
      print("Error uploading file: $e");
      if (mounted) _showError('An error occurred. Please check your connection.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    Navigator.of(context).pop(); // Go back to the home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Replace this with your scanning GIF
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Analyzing your report...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}