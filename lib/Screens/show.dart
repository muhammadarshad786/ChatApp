import 'package:flutter/material.dart';

class ShowScreen extends StatelessWidget {
  final String payload;
  final String body;
  final String title;

  ShowScreen({required this.payload, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const  Text('Notification Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payload: $payload', style: const TextStyle(fontSize: 18)),
           const SizedBox(height: 8),
            Text('Body: $body', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Body: $title', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
