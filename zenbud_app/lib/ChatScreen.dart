import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart' show Content, GenerativeModel;
import 'package:intl/intl.dart';

// Main class representing the chat screen
//Inheritance is used here
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

//Inheritance is used here
class _ChatScreenState extends State<ChatScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController _userMessage = TextEditingController(); // Controller for user input
  bool hasUserSentMessage = false;
  bool isButtonClicked = false;

  static const apiKey = "AIzaSyDShKlHdKYdI4-Hpym-K3jqDmOSj-Beqo8"; // API key for Google Generative Model
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey); // Generative model instance

  final List<Message> _messages = []; // List to hold chat messages

  // Method to send a message using the model and update the chat
  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();

    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
      hasUserSentMessage = true;
    });

    final content = [
      Content.text(message)
    ];
    final response = await model.generateContent(content);
    setState(() {
      _messages.add(Message(isUser: false, message: response.text ?? "", date: DateTime.now()));
    });
  }

  // Another method to send a predefined message
  Future<void> sendMessage1(String message) async {
    _userMessage.text = message;
    _userMessage.clear();

    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
      hasUserSentMessage = true;
    });

    final content = [
      Content.text(message)
    ];
    final response = await model.generateContent(content);
    setState(() {
      _messages.add(Message(isUser: false, message: response.text ?? "", date: DateTime.now()));
    });
  }

  @override
  bool get wantKeepAlive => true; // Keep the state of the widget alive

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          if (!hasUserSentMessage) // Conditionally show the the bakground(logo) image if no messages sent
            Center(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset('assets/zendark.png'),
              ),
            ),
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
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the left
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0), // Padding around the button
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (!isButtonClicked) {
                            sendMessage1('Hi There! My AI ChatBot ');
                            isButtonClicked = true;
                          } else {
                            sendMessage1('Give me a Random Motivation Quote.');
                          }
                        });
                      },
                      child: Text(
                        isButtonClicked ? 'Give me a\nMotivation Quote' : 'Hi There! My AI\nChatBot',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0), // Padding around the button
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (!isButtonClicked) {
                            sendMessage1('Make a study timetable for Today (CS)');
                            isButtonClicked = true;
                          } else {
                            sendMessage1('Got It. Thanks');
                          }
                        });
                      },
                      child: Text(
                        isButtonClicked ? 'Got It.               \nThanks' : 'Make study time \ntable for today',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 46.0, vertical: 20.0),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        // Set the button background color
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 20,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _userMessage,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white10,
                          prefix: const SizedBox(width: 16),
                          suffix: const SizedBox(width: 16),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15), // Adjust vertical padding
                          label: const Text('    Message'),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: const EdgeInsets.all(10),
                      iconSize: 25,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all(
                          const CircleBorder(),
                        ),
                      ),
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(Icons.arrow_upward),
                    )
                  ],
                ),
              ),
            ],
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
  const Messages({super.key, required this.isUser, required this.message, required this.date});

  @override
  Widget build(BuildContext context) {
    final senderName = isUser ? 'Faizan' : 'ZenBud'; // Determine sender name
    final avatarImage = isUser ? 'assets/minion.png' : 'assets/newlogo.png'; // Image path for the avatar

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7), // Adjust vertical padding here
      margin: const EdgeInsets.symmetric(vertical: 1).copyWith(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
          topRight: const Radius.circular(10),
          bottomRight: isUser ? Radius.zero : const Radius.circular(10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 9.5,
            backgroundImage: AssetImage(avatarImage),
          ),
          const SizedBox(width: 9), // Add space between avatar and message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  senderName, // Display sender name without colon
                  style: GoogleFonts.raleway(fontSize: 12, color: isUser ? Colors.grey : Colors.grey),
                ),
                const SizedBox(height: 2), // Add extra space here
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Text(
                    message, // Display message
                    style: GoogleFonts.raleway(fontSize: 15, color: isUser ? Colors.white : Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
