import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  // The screen expects to receive a map of data
  final Map<String, dynamic> data;
  const ResultsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Extracting the data from the map
    final String overallSummary = data['overallSummary'] ?? 'No summary available.';
    final List<dynamic> testSummaries = data['testSummaries'] ?? [];
    final List<dynamic> recommendations = data['recommendations'] ?? [];
    final List<dynamic> doctorQuestions = data['doctorQuestions'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Report Analysis'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Overall Summary Section
          _buildSectionTitle('Overall Summary'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(overallSummary, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 24),

          // Recommendations Section
          _buildSectionTitle('Recommendations'),
          ...recommendations.map((item) => _buildListItem(item)).toList(),
          const SizedBox(height: 24),

          // Questions for Doctor Section
          _buildSectionTitle('Questions for Your Doctor'),
          ...doctorQuestions.map((item) => _buildListItem(item)).toList(),
          const SizedBox(height: 24),

          // Test-by-Test Summary Section
          _buildSectionTitle('Test Details'),
          ...testSummaries.map((item) => _buildListItem(item)).toList(),
        ],
      ),
    );
  }

  // Helper widget to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper widget to build list items
  Widget _buildListItem(String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: const Icon(Icons.check_circle_outline, color: Colors.green),
        title: Text(text),
      ),
    );
  }
}