import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notification_service.dart';

class NotificationForm extends StatefulWidget {
  const NotificationForm({super.key});

  @override
  State<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _payloadController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () {
              context.read<NotificationService>().requestPermission();
            },
            child: Text("Request permission"),
          ),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(label: Text("Title")),
          ),
          spacer,
          TextFormField(
            controller: _bodyController,
            decoration: const InputDecoration(label: Text("Body")),
          ),
          spacer,
          TextFormField(
            controller: _payloadController,
            decoration: const InputDecoration(label: Text("Payload")),
          ),
          spacer,
          ElevatedButton(
            onPressed: () {
              context.read<NotificationService>().show(
                title: _titleController.text,
                body: _bodyController.text,
                payload: {"text": _payloadController.text},
              );
            },
            child: const Text("Show notification"),
          ),
        ],
      ),
    );
  }
}

const spacer = SizedBox(height: 8);
