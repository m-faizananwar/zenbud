import 'package:flutter/material.dart';

class RemindersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          'Reminder',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
