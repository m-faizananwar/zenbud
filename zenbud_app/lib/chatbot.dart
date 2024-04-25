import 'package:flutter/material.dart';

class Chatbotpage extends StatelessWidget {
  const Chatbotpage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          'CHATBOT',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
