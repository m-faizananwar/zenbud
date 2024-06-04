class Reminder {
  int? id;
  String reminderText;
  DateTime reminderDateTime;

  Reminder({this.id, required this.reminderText, required this.reminderDateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reminderText': reminderText,
      'reminderDateTime': reminderDateTime.toIso8601String(),
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      reminderText: map['reminderText'],
      reminderDateTime: DateTime.parse(map['reminderDateTime']),
    );
  }
}