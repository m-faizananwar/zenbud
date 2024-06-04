import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddReminderPage extends StatefulWidget {
  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TextEditingController _reminderController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Reminder',
          style: GoogleFonts.getFont('Nunito', fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1), // Change color to grey
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child: TextField(
                controller: _reminderController,
                decoration: InputDecoration(
                  labelText: 'Enter Reminder',
                  labelStyle: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none, // Remove border
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Select Date',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text(
                'Select Time',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Selected Date: ${_selectedDate.toString()}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Selected Time: ${_selectedTime.format(context)}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_reminderController.text.isNotEmpty) {
                  DateTime reminderDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );
                  Navigator.pop(context, {
                    'reminderText': _reminderController.text,
                    'reminderDateTime': reminderDateTime,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter a reminder'),
                  ));
                }
              },
              child: Text(
                'Save Reminder',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reminderController.dispose();
    super.dispose();
  }
}