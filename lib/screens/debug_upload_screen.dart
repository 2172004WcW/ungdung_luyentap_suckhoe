import 'package:flutter/material.dart';
import '../services/handbook_firestore_service.dart';
import '../models/handbook_topic.dart';

class DebugUploadScreen extends StatefulWidget {
  const DebugUploadScreen({super.key});

  @override
  State<DebugUploadScreen> createState() => _DebugUploadScreenState();
}

class _DebugUploadScreenState extends State<DebugUploadScreen> {
  String _status = 'Idle';

  Future<void> _upload() async {
    // Debug upload removed. Keep screen for historical reference only.
    setState(() => _status = 'Debug upload removed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug: Upload Handbook')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _upload,
              child: const Text('Debug upload (disabled)'),
            ),
            const SizedBox(height: 20),
            Text('Status: $_status'),
            const SizedBox(height: 20),
            const Text('Note: This is a debug helper. Remove after migrating.'),
          ],
        ),
      ),
    );
  }
}
