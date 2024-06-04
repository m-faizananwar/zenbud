import 'package:Zenbud/Quran/globals.dart';
import 'package:Zenbud/Quran/tabs/surah_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                        child: _greeting(),
                      ),
                      SliverAppBar(
                        pinned: true,
                        elevation: 0,
                        backgroundColor: background,
                        automaticallyImplyLeading: false,
                        shape: Border(bottom: BorderSide(width: 3, color: const Color(0xFFAAAAAA).withOpacity(.1))),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(0),
                          child: _tab(),
                        ),
                      )
                    ],
                body: const TabBarView(children: [
                  SurahTab(),
                ])),
          ),
        ),
      ),
    );
  }

  TabBar _tab() {
    return TabBar(unselectedLabelColor: text, labelColor: Colors.white, indicatorColor: primary, indicatorWeight: 3, tabs: [
      _tabItem(label: "Surah"),
    ]);
  }

  Tab _tabItem({required String label}) {
    return Tab(
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Column _greeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assalam o alaikum',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: text),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'Blessings',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        const SizedBox(
          height: 24,
        ),
        _lastRead()
      ],
    );
  }

  Stack _lastRead() {
    return Stack(
      children: [
        Container(
          height: 131,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [
                0,
                .6,
                1
              ], colors: [
                Color.fromARGB(255, 126, 212, 83),
                Color.fromARGB(255, 126, 212, 83),
                Color.fromARGB(255, 126, 212, 83)
              ])),
        ),
        Positioned(bottom: 0, right: 0, child: SvgPicture.asset('assets/svgs/quran.svg')),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svgs/book.svg'),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Last Read',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Al-Fatihah',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Ayat No: 1',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
