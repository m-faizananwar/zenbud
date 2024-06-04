import 'dart:async';

import 'package:Zenbud/screens/edit_alarm.dart';
import 'package:Zenbud/screens/ring.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPagee extends StatefulWidget {
  const AlarmPagee({super.key});

  @override
  State<AlarmPagee> createState() => _AlarmPageeState();
}

class _AlarmPageeState extends State<AlarmPagee> {
  late List<AlarmSettings> alarms;
  final List<bool> _alarmOnOff = [];

  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
    }
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
          (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();

      for (int i = 0; i < alarms.length; i++) {
        if (alarms[i].dateTime.year == 2050) {
          _alarmOnOff.add(false);
        } else {
          _alarmOnOff.add(true);
        }
      }
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExampleAlarmRingScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExampleAlarmEditScreen(alarmSettings: settings),
      ),
    );

    if (res != null && res == true) loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Center(
              child: Realtime(),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => navigateToAlarmScreen(null),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            alarms.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  return _buildAlarmCard(alarms[index], index);
                },
              ),
            )
                : Expanded(
              child: Center(
                child: Text(
                  "No Alarms Set",
                  style: GoogleFonts.raleway(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _hour(TimeOfDay time) {
    int hour = 0;
    String ampm = 'am';
    if (time.hour > 12) {
      hour = time.hour - 12;
      ampm = 'pm';
    } else if (time.hour == 0) {
      hour = 12;
    } else {
      hour = time.hour;
      ampm = 'am';
    }

    return [
      hour.toString().padLeft(2, '0'),
      ampm,
    ];
  }

  Widget _buildAlarmCard(AlarmSettings alarm, int index) {
    TimeOfDay time = TimeOfDay.fromDateTime(alarm.dateTime);
    String formattedDate = DateFormat('EEE, d MMM').format(alarm.dateTime);
    return GestureDetector(
      onTap: () => navigateToAlarmScreen(alarms[index]),
      child: Slidable(
        closeOnScroll: true,
        endActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(12),
              onPressed: (context) {
                Alarm.stop(alarm.id);
                loadAlarms();
              },
              icon: Icons.delete_forever,
              backgroundColor: Colors.red.shade700,
            ),
          ],
        ),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(""),
              ListTile(
                splashColor: null,
                dense: true,
                minVerticalPadding: 10,
                horizontalTitleGap: 10,
                enabled: false,
                title: Row(
                  children: [
                    Text(
                      "${_hour(time)[0]}:${time.minute.toString().padLeft(2, '0')} ",
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.start,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(_hour(time)[1]),
                    ),
                    const Expanded(child: Text("")),
                    Text(formattedDate.toString()),
                  ],
                ),
                trailing: Switch(
                  value: _alarmOnOff[index],
                  onChanged: (bool value) {
                    if (value == false) {
                      Alarm.set(
                        alarmSettings: alarm.copyWith(
                          dateTime: alarm.dateTime.copyWith(year: 2050),
                        ),
                      );
                    } else {
                      Alarm.set(
                        alarmSettings: alarm.copyWith(
                          dateTime: alarm.dateTime.copyWith(year: DateTime.now().year),
                        ),
                      );
                    }
                    setState(() {
                      _alarmOnOff[index] = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class Realtime extends StatefulWidget {
  const Realtime({super.key});

  @override
  RealtimeState createState() => RealtimeState();
}

class RealtimeState extends State<Realtime> {
  late StreamController<DateTime> _clockStreamController;
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _clockStreamController = StreamController<DateTime>();
    _startClock();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _currentTime = DateTime.now();
      _clockStreamController.add(_currentTime);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _clockStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat('hh:mm a').format(_currentTime); // 12-hour format

    return StreamBuilder<DateTime>(
      stream: _clockStreamController.stream,
      initialData: _currentTime,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "It's                                                            ",
              style: GoogleFonts.numans(
                fontSize: 10,
              ),
            ),
            RichText(
              text: TextSpan(
                style: GoogleFonts.numans(
                  textStyle: Theme.of(context).textTheme.headlineLarge,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: DateFormat('hh:mm').format(snapshot.data!),
                    style: GoogleFonts.numans(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      fontWeight: FontWeight.bold,
                      fontSize: 75,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat(' a').format(snapshot.data!),
                    style: GoogleFonts.numans(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}