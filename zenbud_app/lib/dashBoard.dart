import 'package:Zenbud/Quran/quran.dart';
import 'package:Zenbud/pomodoro_clock.dart';
import 'package:Zenbud/quotes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String username = 'Faizan Anwar';
  int level = 1;
  int days = 5;
  int index = 0;
  void changeIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> parts = username.split(' ');
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: IndexedStack(
            index: index,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${parts[0]}  ',
                            style: GoogleFonts.raleway(
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            parts[1],
                            style: GoogleFonts.raleway(fontSize: 30, fontWeight: FontWeight.w500, color: Color.fromRGBO(128, 128, 128, 1)),
                          ),
                          SizedBox(width: 70),
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage('assets/minion.png'),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Icon(IconData(0x1F451)),
                          SizedBox(width: 10),
                          Text(
                            '   Level ${level}',
                            style: GoogleFonts.ubuntu(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            width: 90,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 145,
                          width: 140,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/streak.png',
                                  width: 100,
                                  height: 90,
                                ),
                                Text(
                                  'Streak',
                                  style: GoogleFonts.raleway(fontSize: 18, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 145,
                          width: 140,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              print('Quran Button tapped');
                              changeIndex(1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/quran.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                  Text(
                                    'Quran',
                                    style: GoogleFonts.raleway(fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Quote(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 180,
                      width: 375,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        image: DecorationImage(
                          image: AssetImage('assets/pomodaro.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          print('Quran Button tapped');
                          changeIndex(2);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Quran(changeindex: changeIndex),
              Pomodoro(),
            ],
          ),
        ),
      ),
    );
  }
}
