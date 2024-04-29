import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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
  Map<int, double> weeklyUsage = {
    for (var i = 0; i < 7; i++) i: 0.0
  };
  String selectedDate = '';

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
        for (var info in infos) {
          int dayOfWeek = info.startDate.weekday - 1; // Monday is 1 in Dart, but we want it to be 0
          weeklyUsage[dayOfWeek] = (weeklyUsage[dayOfWeek] ?? 0) + info.usage.inSeconds / 3600; // Convert to hours
        }
      });
    } on AppUsageException catch (exception) {
      print(exception);
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
          Container(
            height: 250,
            child: Column(
              children: [
                Text(
                  selectedDate.isNotEmpty ? selectedDate : 'Select a day to see total screen time',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final dayOfWeek = group.x.toInt();
                            final date = DateTime.now().subtract(Duration(days: DateTime.now().weekday - dayOfWeek - 1));
                            final formattedDate = DateFormat('EEE, MMM d').format(date);
                            setState(() {
                              selectedDate = '$formattedDate: ${rod.toY.toStringAsFixed(2)} hours';
                            });
                            return BarTooltipItem(
                              formattedDate,
                              const TextStyle(color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${rod.toY.toStringAsFixed(2)} hours',
                                  style: const TextStyle(color: Colors.yellow),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      barGroups: weeklyUsage.entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              width: 40,
                              rodStackItems: [
                                BarChartRodStackItem(0, entry.value, Colors.blue),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      gridData: FlGridData(
                        drawHorizontalLine: true,
                        horizontalInterval: 2,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.5),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return const FlLine(
                            color: Colors.transparent,
                            strokeWidth: 0,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final dayOfWeek = value.toInt();
                              final dayName = DateFormat('EEE').format(
                                DateTime.now().subtract(
                                  Duration(days: DateTime.now().weekday - dayOfWeek - 1),
                                ),
                              );
                              return Text(
                                dayName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false, // Hide left titles
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true, // Show right titles
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                '${value.toInt()} h',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                        return const SizedBox.shrink(); // Don't display the app if the icon is invalid
                      }
                      int usageInSeconds = _infos[index].usage.inSeconds;
                      String usageString = "${usageInSeconds ~/ 3600}h ${(usageInSeconds % 3600) ~/ 60}m ${(usageInSeconds % 60)}s";
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
