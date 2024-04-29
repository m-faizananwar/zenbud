import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State {
  final audioplayer = AudioPlayer();
  bool isplaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String? audioFilePath; // Add a variable to store the audio file path

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Future<void> setaudio() async {
    audioplayer.setReleaseMode(ReleaseMode.loop);
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      setState(() {
        audioFilePath = file.path; // Update the audio file path
      });
      audioplayer.setSourceUrl(audioFilePath!); // Set audio URL
    }
  }

  @override
  void initState() {
    super.initState();
// Initialize audio player without selecting a file
    audioplayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isplaying = state == PlayerState.playing;
      });
    });
    audioplayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioplayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioplayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/goku.jpg', // Provide the correct asset path
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "THE FLUTTER SONG",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "GOKU SONG",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioplayer.seek(position);
                await audioplayer.resume();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration - position))
                ],
              ),
            ),
            CircleAvatar(
              radius: 30,
              child: IconButton(
                icon: Icon(
                  isplaying ? Icons.pause : Icons.play_arrow,
                ),
                iconSize: 40,
                onPressed: () async {
                  if (isplaying) {
                    await audioplayer.pause();
                  } else {
                    await setaudio(); // Set audio source if not set
                    await audioplayer.resume(); // Start playing the audio
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
