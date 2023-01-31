extension DateOnlyCompare on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String formatDateAndTime() {
    return "${formatTime()}, ${formatDate()}";
  }

  String formatDate() {
    return "$day-$month-$year";
  }

  String formatTime() {
    String hours = hour.toString().padLeft(2, "0");
    String minutes = minute.toString().padLeft(2, "0");

    return "$hours:$minutes";
  }

  String getWeekDayName() {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
    }

    throw Exception("Invalid week day");
  }
}
