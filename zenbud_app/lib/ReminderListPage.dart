import 'package:Zenbud/Reminder1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'AddReminderPage.dart';
import 'databasehelper.dart';

class ReminderListPage extends StatefulWidget {
  @override
  _ReminderListPageState createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  late Future<List<Reminder>> _remindersFuture;

  @override
  void initState() {
    super.initState();
    _refreshReminders();
  }

  void _refreshReminders() {
    setState(() {
      _remindersFuture = DatabaseHelper().getReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: FutureBuilder<List<Reminder>>(
        future: _remindersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/owl2.png', // Replace with the path to your owl image
                    width: 200,
                    height: 150,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No Reminders',
                    style: GoogleFonts.raleway(fontSize: 20),
                  ),
                ],
              ),
            );
          } else {
            List<Reminder> reminders = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Tasks',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      Color color = Colors.grey.withOpacity(0.1);
                      Reminder reminder = reminders[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(
                            reminder.reminderText,
                            style: GoogleFonts.getFont(
                              'Nunito',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(reminder.reminderDateTime)}',
                            style: GoogleFonts.getFont(
                              'Nunito',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              DatabaseHelper().deleteReminder(reminder.id!);
                              _refreshReminders();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Map<String, dynamic>? result = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(builder: (context) => AddReminderPage()),
          );
          if (result != null) {
            Reminder reminder = Reminder(
              reminderText: result['reminderText'],
              reminderDateTime: result['reminderDateTime'],
            );
            await DatabaseHelper().insertReminder(reminder);
            _refreshReminders();
          }
        },
        backgroundColor: Colors.grey.withOpacity(1),
        child: Icon(Icons.add),
      ),
    );
  }
}
