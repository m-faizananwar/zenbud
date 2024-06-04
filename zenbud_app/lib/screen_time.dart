import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenTimePage extends StatelessWidget {
  const ScreenTimePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const AppUsageWidget();
  }
}

class AppUsageWidget extends StatefulWidget {
  const AppUsageWidget({super.key});
  @override
  AppUsageWidgetState createState() => AppUsageWidgetState();
}

class AppUsageWidgetState extends State<AppUsageWidget> {
  List<AppUsageInfo> _infos = [];
  int totalUsage = 0;

  @override
  void initState() {
    super.initState();
    getAppUsage();
  }

  void getAppUsage() async {
    try {
      DateTime today = DateTime.now();
      DateTime yesterday = DateTime(today.year, today.month, today.day, 0, 0, 0);
      AppUsage appUsage = AppUsage();
      List<AppUsageInfo> infos = await appUsage.getAppUsage(yesterday, today);
      setState(() {
        _infos = infos;
        totalUsage = _infos.fold(0, (prev, info) => prev + info.usage.inSeconds);
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  Image getImage(int usage) {
    if (usage ~/ 3600 > 10) {
      return Image.asset('assets/surprise.jpg', width: 50, height: 50);
    } else if (usage ~/ 3600 > 15) {
      return Image.asset('assets/shit.png', width: 50, height: 50);
    } else {
      return Image.asset(
        'assets/happy.png',
        width: 200,
        height: 200,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Usage'),
      ),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.grey.withOpacity(0.1),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        'Total Usage: ${totalUsage ~/ 3600}h ${(totalUsage % 3600) ~/ 60}m ${(totalUsage % 60)}s',
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        height: 80,
                        width: 80,
                        child: getImage(totalUsage),
                      ),
                    ],
                  ),
                )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _infos.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: DeviceApps.getApp(_infos[index].packageName, true),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Application? app = snapshot.data;
                      if (app is! ApplicationWithIcon) {
                        return const SizedBox.shrink();
                      }
                      int usageInSeconds = _infos[index].usage.inSeconds;
                      String usageString = "${usageInSeconds ~/ 3600}h ${(usageInSeconds % 3600) ~/ 60}m ${(usageInSeconds % 60)}s";
                      totalUsage += usageInSeconds;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: Image.memory(app.icon),
                          title: Text(app.appName),
                          subtitle: Text(usageString),
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}