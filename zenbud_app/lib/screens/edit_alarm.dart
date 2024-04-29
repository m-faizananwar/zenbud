import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ExampleAlarmEditScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const ExampleAlarmEditScreen({Key? key, this.alarmSettings})
      : super(key: key);

  @override
  State<ExampleAlarmEditScreen> createState() => _ExampleAlarmEditScreenState();
}

DateTime selectedDateTime = DateTime.now();

class _ExampleAlarmEditScreenState extends State<ExampleAlarmEditScreen> {
  bool loading = false;

  late bool creating;

  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late String assetAudio;
  int hour = 0;
  int minute = 0;
  String amPm = 'AM';
  FixedExtentScrollController _minuteController = FixedExtentScrollController();
  FixedExtentScrollController _hourController = FixedExtentScrollController();
  FixedExtentScrollController _ampmController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      assetAudio = 'assets/alarm.mp3';
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
    int initialMinute = 30;
    _minuteController =
        FixedExtentScrollController(initialItem: selectedDateTime.minute);
    _hourController =
        FixedExtentScrollController(initialItem: selectedDateTime.hour - 1);
    if (selectedDateTime.hour > 12) {
      _ampmController = FixedExtentScrollController(initialItem: 1);
    }
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Today - ${DateFormat('EEE, d MMM').format(selectedDateTime)}';
      case 1:
        return 'Tomorrow - ${DateFormat('EEE, d MMM').format(selectedDateTime)}';
      default:
        return DateFormat('EEE, d MMM').format(selectedDateTime);
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final DateTime now = DateTime.now();
        selectedDateTime = now.copyWith(
            hour: res.hour,
            minute: res.minute,
            second: 0,
            millisecond: 0,
            microsecond: 0);
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume,
      assetAudioPath: assetAudio,
      notificationTitle: 'Alarm example',
      notificationBody: 'Your alarm ($id) is ringing',
    );
    return alarmSettings;
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res) Navigator.pop(context, true);
      setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    /* return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: saveAlarm,
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(
                        "Save",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.blueAccent),
                      ),
              ),
            ],
          ),
          Text(getDay(), style: Theme.of(context).textTheme.titleMedium!
              // .copyWith(color: Colors.blueAccent.withOpacity(0.8)),
              ),
          RawMaterialButton(
            onPressed: pickTime,
            // fillColor: Colors.grey[200],
            child: Text(
                TimeOfDay.fromDateTime(selectedDateTime).format(context),
                style: Theme.of(context).textTheme.displayMedium!
                // .copyWith(color: Colors.blueAccent),
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loop alarm audio',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: loopAudio,
                onChanged: (value) => setState(() => loopAudio = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vibrate',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: vibrate,
                onChanged: (value) => setState(() => vibrate = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sound',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: assetAudio,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'assets/marimba.mp3',
                    child: Text('Marimba'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/nokia.mp3',
                    child: Text('Nokia'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/mozart.mp3',
                    child: Text('Mozart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/star_wars.mp3',
                    child: Text('Star Wars'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/one_piece.mp3',
                    child: Text('One Piece'),
                  ),
                ],
                onChanged: (value) => setState(() => assetAudio = value!),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Custom volume',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: volume != null,
                onChanged: (value) =>
                    setState(() => volume = value ? 0.5 : null),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            child: volume != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        volume! > 0.7
                            ? Icons.volume_up_rounded
                            : volume! > 0.1
                                ? Icons.volume_down_rounded
                                : Icons.volume_mute_rounded,
                      ),
                      Expanded(
                        child: Slider(
                          value: volume!,
                          onChanged: (value) {
                            setState(() => volume = value);
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          const SizedBox(),
        ],
      ),
    );
  }*/
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CupertinoPicker(
                    squeeze: 0.8,
                    diameterRatio: 5,
                    useMagnifier: true,
                    looping: true,
                    itemExtent: 100,
                    scrollController: _hourController,
                    selectionOverlay:
                    const CupertinoPickerDefaultSelectionOverlay(
                      background: Colors.transparent,
                      capEndEdge: true,
                      // capStartEdge: true,
                    ),
                    onSelectedItemChanged: ((value) {
                      setState(() {
                        hour = value + 1;
                      });
                      _time();
                    }),
                    children: [
                      for (int i = 1; i <= 12; i++) ...[
                        Center(
                          child: Text(
                            '$i',
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Text(
                  ":",
                  style: TextStyle(fontSize: 50),
                ),
                Flexible(
                  flex: 1,
                  child: CupertinoPicker(
                    squeeze: 0.8,
                    diameterRatio: 5,
                    looping: true,
                    itemExtent: 100,
                    scrollController: _minuteController,
                    selectionOverlay:
                    const CupertinoPickerDefaultSelectionOverlay(
                      background: Colors.transparent,
                      capEndEdge: true,
                      // capStartEdge: true,
                    ),
                    onSelectedItemChanged: ((value) {
                      setState(() {
                        minute = value;
                        _time();
                      });
                    }),
                    children: [
                      for (int i = 0; i <= 59; i++) ...[
                        Center(
                          child: Text(
                            i.toString().padLeft(2, '0'),
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CupertinoPicker(
                    // offAxisFraction: 10,
                    squeeze: 1,
                    diameterRatio: 15,
                    useMagnifier: true,
                    // looping: true,
                    itemExtent: 100,
                    scrollController: _ampmController,
                    selectionOverlay:
                    const CupertinoPickerDefaultSelectionOverlay(
                      background: Colors.transparent,
                      // capEndEdge: true,
                      // capStartEdge: true,
                    ),
                    onSelectedItemChanged: ((value) {
                      if (value == 0) {
                        setState(() {
                          amPm = "AM";
                        });
                      } else {
                        setState(() {
                          amPm = "PM";
                        });
                      }
                      _time();
                    }),
                    children: [
                      for (var i in ['am', 'pm']) ...[
                        Center(
                          child: Text(
                            i,
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // const SizedBox(
                    //   height: 25,
                    // ),
                    ListTile(
                      title: Text(getDay()),
                      trailing: IconButton(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_month_outlined)),
                    ),
                    // Center(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       IconButton(onPressed: () {}, icon: Text("M")),
                    //       IconButton(onPressed: () {}, icon: Text("T")),
                    //       IconButton(onPressed: () {}, icon: Text("W")),
                    //       IconButton(onPressed: () {}, icon: Text("T")),
                    //       IconButton(onPressed: () {}, icon: Text("F")),
                    //       IconButton(onPressed: () {}, icon: Text("S")),
                    //       IconButton(
                    //           onPressed: () {},
                    //           icon: const Text(
                    //             "S",
                    //             style: TextStyle(color: Colors.redAccent),
                    //           )),
                    //     ],
                    //   ),
                    // ),
                    // const Padding(
                    //   padding: EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                    //   child: TextField(
                    //       // controller: '_alarmname',
                    //       ),
                    // ),

                    ListTile(
                      title: const Text("Alarm Sound"),
                      // subtitle: const Text("Basic Bell"),
                      trailing: DropdownButton(
                        value: assetAudio,
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'assets/alarm.mp3',
                            child: Text('alarm'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'assets/nokia.mp3',
                            child: Text('Nokia'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'assets/mozart.mp3',
                            child: Text('Mozart'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'assets/star_wars.mp3',
                            child: Text('Star Wars'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'assets/one_piece.mp3',
                            child: Text('One Piece'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => assetAudio = value!),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(),
                    ),
                    ListTile(
                      title: const Text("Vibration"),
                      // subtitle: Text("Basic call"),
                      trailing: Switch(
                          inactiveThumbColor: null,
                          value: vibrate,
                          onChanged: (value) =>
                              setState(() => vibrate = value)),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(),
                    ),
                    ListTile(
                      title: const Text("Volume level"),
                      // subtitle: const Text("Basic Bell"),
                      trailing: Switch(
                        value: volume != null,
                        onChanged: (value) =>
                            setState(() => volume = value ? 0.5 : null),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                      child: volume != null
                          ? Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              volume! > 0.7
                                  ? Icons.volume_up_rounded
                                  : volume! > 0.1
                                  ? Icons.volume_down_rounded
                                  : Icons.volume_mute_rounded,
                            ),
                            Expanded(
                              child: Slider(
                                value: volume!,
                                onChanged: (value) {
                                  setState(() => volume = value);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                          : const SizedBox(),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: saveAlarm,
                  icon: Text(
                    "Save",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _time() {
    String timeString =
        "$hour:$minute $amPm"; // Replace this with your time string

    DateTime dateTime = convertStringToDateTime(timeString);
    setState(() {
      selectedDateTime = dateTime;
      if (selectedDateTime.isBefore(DateTime.now())) {
        selectedDateTime = selectedDateTime.add(const Duration(days: 1));
      }
      getDay();
    });
  }

  DateTime convertStringToDateTime(String timeString) {
    DateFormat format = DateFormat('hh:mm a');
    DateTime dateTime = format.parse(timeString);

    // Assuming you want to set the date part to today
    DateTime today = DateTime.now();
    dateTime = DateTime(
        today.year, today.month, today.day, dateTime.hour, dateTime.minute);

    return dateTime;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? now = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        currentDate: selectedDateTime,
        lastDate: DateTime(2030, 12, 31));

    if (now != null) {
      setState(() {
        selectedDateTime = now;
        if (selectedDateTime.isBefore(DateTime.now())) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
        getDay();
      });
    }
  }
}









