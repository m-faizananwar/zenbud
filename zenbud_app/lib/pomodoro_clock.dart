import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  int _minutes = 25;
  late Timer _timer;
  var f = NumberFormat("00");

  @override
  void initState() {
    super.initState();
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
          }
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _seconds = 0;
      _minutes = 25;
    });
  }

  void _startTimer() {
    _stopTimer();
    if (_minutes > 0) {
      _seconds = _minutes * 60;
    }
    if (_seconds > 60) {
      _minutes = (_seconds / 60).floor();
      _seconds -= (_minutes * 60);
    }
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
          }
        }
      });
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
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 150,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100, // Roboto Thin
                      ),
                    ),
                    // Add some space between minutes and seconds
                    Text(
                      f.format(_seconds % 60),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 80,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100, // Roboto Thin
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _stopTimer();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Stop",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _startTimer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Start",
                    style: TextStyle(
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
