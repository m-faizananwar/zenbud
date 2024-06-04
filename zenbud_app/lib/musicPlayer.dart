import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: MusicPlayerPage(),
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white, // Set primary color to grey
        hintColor: Colors.grey[400], // Set hint color to a shade of grey
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      ),
    );
  }
}

class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              children: [
                Text(
                  '       Music Player',
                  style: GoogleFonts.pacifico(
                    fontSize: 25,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: null, // Non-functional button
          ),
        ],
      ),
      body: PlayButton(),
    );
  }
}

class PlayButton extends StatefulWidget {
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double _sliderValue = 0.0;
  Duration _duration = Duration();
  Duration _position = Duration();
  int currentMusicIndex = 0; // Track current music index

  List<String> musics = ["music2.mp3", "music1.mp3"]; // Swapped music files
  List<String> images = ["assets/music2.jpg", "assets/music1.jpg"]; // Swapped image paths
  List<String> songNames = ["Slowed Lofi(Reverb Version )", "Marcos Lofi-Slowed Version"]; // Swapped song names
  List<String> artistNames = ["Chahat Fateh Ali Khan", "Andrew Edison"]; // Swapped artist names
  List<Color> overlayColors = [
    Colors.purple.withOpacity(0.1), // Swapped overlay colors
    Colors.lightBlue.withOpacity(0.1)
  ];

  @override
  void initState() {
    super.initState();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        _sliderValue = position.inMilliseconds.toDouble();
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        _sliderValue = 0.0;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(AssetSource(musics[currentMusicIndex]));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> _seekAudio(double value) async {
    final position = Duration(milliseconds: value.toInt());
    await audioPlayer.seek(position);
  }

  Future<void> _playNext() async {
    currentMusicIndex = (currentMusicIndex + 1) % musics.length;
    await audioPlayer.stop();
    await audioPlayer.play(AssetSource(musics[currentMusicIndex]));
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> _playPrevious() async {
    currentMusicIndex = (currentMusicIndex - 1) % musics.length;
    if (currentMusicIndex < 0) {
      currentMusicIndex = musics.length - 1;
    }
    await audioPlayer.stop();
    await audioPlayer.play(AssetSource(musics[currentMusicIndex]));
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Duration remainingTime = _duration - _position;

    return Stack(
      children: [
        Container(
          color: overlayColors[currentMusicIndex], // Background color with opacity
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100), // Added SizedBox for spacing between AppBar and image
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: ClipRRect(
                key: ValueKey<int>(currentMusicIndex),
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  images[currentMusicIndex],
                  width: 350,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20), // Reduced height between widgets
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Reduced vertical padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          songNames[currentMusicIndex], // Display song name
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      artistNames[currentMusicIndex], // Display artist name
                      style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey, // Set text color to grey
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.grey.shade800.withOpacity(0.5),
                      inactiveTrackColor: Colors.grey.shade700.withOpacity(0.5),
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 2.5,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                      thumbColor: Colors.white,
                      overlayColor: Colors.grey.withAlpha(32),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.grey[700],
                      inactiveTickMarkColor: Colors.grey.shade600,
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.grey.shade600,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: 0.0,
                      max: _duration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                        _seekAudio(value);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${remainingTime.inMinutes}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Increased spacing below the slider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 21.0,
                  icon: Icon(Icons.shuffle, color: Colors.white),
                  onPressed: null,
                ),
                SizedBox(width: 20),
                IconButton(
                  iconSize: 48.0,
                  icon: Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: _playPrevious,
                ),
                SizedBox(width: 20),
                Container(
                  width: 72.0,
                  height: 72.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    iconSize: 48.0,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 48.0,
                      color: Colors.black,
                    ),
                    onPressed: _toggleAudio,
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  iconSize: 48.0,
                  icon: Icon(Icons.skip_next, color: Colors.white),
                  onPressed: _playNext,
                ),
                IconButton(
                  iconSize: 21.0,
                  icon: Icon(Icons.loop, color: Colors.white),
                  onPressed: null,
                ),
                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
