import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  final List<Map<String, String>> events = const [
    {
      'title': 'Latte Art Throwdown',
      'date': 'June 5, 2025',
      'description': 'Watch local baristas compete with their frothy skills!',
    },
    {
      'title': 'New Café Opening: Bean Bliss',
      'date': 'June 10, 2025',
      'description': 'Come enjoy free samples and live acoustic music!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Events & Promos")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(event['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event['date']!, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(event['description']!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}