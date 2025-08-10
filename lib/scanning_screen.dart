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

  // In scanning_screen.dart

  Future<void> _uploadAndAnalyze(String imagePath) async {
    final dio = Dio();
    final file = File(imagePath);
    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    try {
      // Make sure this IP is correct for your network
      final response = await dio.post('http://192.168.1.2:8000/api/analyze/', data: formData);

      if (response.statusCode == 200 && mounted) {

        // --- THE FIX IS HERE ---
        Map<String, dynamic> analysisData;

        // Check if the data is already a Map or if it's a String that needs decoding
        if (response.data is Map<String, dynamic>) {
          analysisData = response.data;
        } else if (response.data is String) {
          analysisData = jsonDecode(response.data as String);
        } else {
          // If it's neither, something is wrong with the response format
          throw Exception("Invalid response format from server.");
        }
        // --- END OF FIX ---

        // Now that we have a real Map, we can navigate
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResultsScreen(data: analysisData)),
        );

      } else {
        if (mounted) _showError('Failed to get analysis. Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      // This will catch network errors or other issues like the format exception.
      print("Error during API call or data processing: $e");
      if (mounted) _showError('An error occurred. Please check your connection or server logs.');
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