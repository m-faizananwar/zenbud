import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userMessage = TextEditingController();

  static const apiKey = "AIzaSyDShKlHdKYdI4-Hpym-K3jqDmOSj-Beqo8";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();

    setState(() {
      // Add user message to the chat
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    // Send the user message to the bot and wait for the response
    final content = [
      Content.text(message)
    ];
    final response = await model.generateContent(content);
    setState(() {
      // Add bot's response to the chat
      _messages.add(Message(isUser: false, message: response.text ?? "", date: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Messages(
                      isUser: message.isUser,
                      message: message.message,
                      date: DateFormat('HH:mm').format(message.date),
                      name: '',
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 70,
                        child: TextFormField(
                          controller: _userMessage,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelText: "Enter your message",
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        padding: const EdgeInsets.all(10),
                        iconSize: 28,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            const CircleBorder(),
                          ),
                        ),
                        onPressed: () {
                          sendMessage();
                        },
                        icon: const Icon(Icons.send),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          // Centered logo with 50% opacity
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset('assets/zendark.png'),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;
  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  const Messages({super.key, required this.isUser, required this.message, required this.date, required String name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 1).copyWith(),
      decoration: BoxDecoration(
          //color: isUser ? Colors.blueAccent : Colors.grey.shade400,
          borderRadius: BorderRadius.only(topLeft: const Radius.circular(10), bottomLeft: isUser ? const Radius.circular(10) : Radius.zero, topRight: const Radius.circular(10), bottomRight: isUser ? Radius.zero : const Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16, color: isUser ? Colors.grey : Colors.grey),
          ),
          //Text(
          //date,
          //style: TextStyle(fontSize: 10,color: isUser ? Colors.white: Colors.black,),
          // )
        ],
      ),
    );
  }
}
