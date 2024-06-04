import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Pomodoro(),
    );
  }
}

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key? key});

  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  int _seconds = 0;
  int _minutes = 25; // Initial main timer duration set to 25 minute
  int _lastSelectedMinutes = 21; // Store the last selected duration
  late Timer _timer;
  var f = NumberFormat("00");
  bool _isRunning = false;
  bool _isBreakTime = false;
  bool _showTimerButtons = false;

  void initState() {
    super.initState();
    _updateTimer();
  }

  void _updateTimer() {
    if (_isRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            if (_minutes > 0) {
              _seconds = 59;
              _minutes--;
            } else {
              _timer.cancel();
              print("Timer Complete");

              if (_isBreakTime) {
                _minutes = 25; // Reset work timer
                _isBreakTime = false;
              } else {
                _minutes = 5; // Set break time to 5 minutes
                _isBreakTime = true;
              }

              _updateTimer(); // Start the new timer
            }
          }
        });
      });
    }
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _timer.cancel();
        _isRunning = false;
        _isBreakTime = false; // Reset to work time
      } else {
        _isRunning = true;
        _updateTimer();
      }
    });
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
      _seconds = 0;
      _minutes = _lastSelectedMinutes; // Reset to the last selected duration
      _isBreakTime = false; // Reset to work time
    });
  }

  void _changeMainTimer(int minutes) {
    if (!_isRunning) {
      setState(() {
        _minutes = minutes;
        _lastSelectedMinutes = minutes; // Store the new selected duration
        _showTimerButtons = false; // Hide the additional timer buttons
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pomodoro Timer",
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(
              fontSize: 30.0,

            ),
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _showTimerButtons = !_showTimerButtons;
              });
            },
            child: Icon(Icons.timer),
            mini: true,
            backgroundColor: Colors.black,
          ),

          if (_showTimerButtons)
            ...[
              SizedBox(height: 8),
              FloatingActionButton(
                onPressed: () => _changeMainTimer(25),
                child: Text("25"),
                mini: true,
                backgroundColor: Colors.black,
              ),
              SizedBox(height: 8),
              FloatingActionButton(
                onPressed: () => _changeMainTimer(35),
                child: Text("35"),
                mini: true,
                backgroundColor: Colors.black,
              ),
              SizedBox(height: 8),
              FloatingActionButton(
                onPressed: () => _changeMainTimer(45),
                child: Text("45"),
                mini: true,
                backgroundColor: Colors.black,
              ),
            ],
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: _resetTimer,
            child: Icon(Icons.refresh),
            backgroundColor: Colors.black,
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: _toggleTimer,
            child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
            backgroundColor: Colors.black,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    f.format(_minutes ~/ 1),
                    style: GoogleFonts.bebasNeue(
                      textStyle: TextStyle(
                        color: Colors.grey.shade800, // Change color to light brown
                        fontSize: 200, // Set size to match FABs
                        fontWeight: FontWeight.bold, // Make it bold
                      ),
                    ),
                  ),
                  Text(
                    f.format(_seconds % 60),
                    style: GoogleFonts.bebasNeue(
                      textStyle: TextStyle(
                        color: Colors.grey.shade800, // Change color to light brown
                        fontSize: 200, // Set size to match FABs
                        fontWeight: FontWeight.bold, // Make it bold
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
