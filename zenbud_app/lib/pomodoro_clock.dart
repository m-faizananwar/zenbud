import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Pomodoro(),
    );
  }
}

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  PomodoroState createState() => PomodoroState();
}

class PomodoroState extends State<Pomodoro> {
  int _seconds = 0;
  int _minutes = 25;
  late Timer _timer;
  var f = NumberFormat("00");
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _updateTimer();
  }

  void _updateTimer() {
    if (_isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
              _isRunning = false;
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
      _minutes = 25;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < 1; i++)
                Column(
                  children: [
                    Text(
                      f.format(_minutes ~/ 1),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 150,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    // Add some space between minutes and seconds
                    Text(
                      f.format(_seconds % 60),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 80,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _resetTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _toggleTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRunning ? Colors.redAccent : Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _isRunning ? "Pause" : "Start",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
