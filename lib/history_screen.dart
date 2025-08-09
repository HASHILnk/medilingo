import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'results_screen.dart';
import 'package:intl/intl.dart'; // For formatting dates

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Dio _dio = Dio();
  Future<List<dynamic>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  Future<List<dynamic>> _fetchHistory() async {
    try {
      final response = await _dio.get('http://192.168.16.243:8000/api/history/');
      return response.data;
    } catch (e) {
      print("Error fetching history: $e");
      throw Exception('Failed to load history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load history.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history found.'));
          }

          final reports = snapshot.data!;
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final analysisData = report['analysis_data'];
              final date = DateTime.parse(report['analysis_date']);
              final formattedDate = DateFormat('MMMM dd, yyyy - hh:mm a').format(date);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text("Report from: $formattedDate"),
                  subtitle: Text(
                    analysisData['overallSummary'] ?? 'No summary.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsScreen(data: analysisData),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}