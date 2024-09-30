// import 'package:intl/intl.dart'; 

// class DateTimeFormatter {
//   /// Formats a DateTime object to a readable string.
//   static String formatTime(DateTime dateTime) {
//     return DateFormat('hh:mm a').format(dateTime); // Formats to "HH:MM AM/PM"
//   }

//   /// Formats a DateTime object to a date string.
//   static String formatDate(DateTime dateTime) {
//     return DateFormat('MMMM dd, yyyy').format(dateTime); // e.g., "September 30, 2024"
//   }

//   /// Formats a DateTime object to a full date and time string.
//   static String formatFull(DateTime dateTime) {
//     return DateFormat('MMMM dd, yyyy, hh:mm a').format(dateTime); // e.g., "September 30, 2024, 12:34 PM"
//   }

//   /// Formats a DateTime object to a short date string.
//   static String formatShort(DateTime dateTime) {
//     return DateFormat('MM/dd/yyyy').format(dateTime); // e.g., "09/30/2024"
//   }
// }

class CustomDateTimeFormatter {
  static String formatTime(DateTime dateTime) {
    // Format time as "HH:MM AM/PM"
    return '${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
  }

  static String formatDate(DateTime dateTime) {
    // Format date as "Month Day, Year"
    return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
  }

  static String formatFull(DateTime dateTime) {
    // Format full date and time
    return '${formatDate(dateTime)}, ${formatTime(dateTime)}';
  }

  static String formatShort(DateTime dateTime) {
    // Format short date as "MM/DD/YYYY"
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  static String _getMonthName(int month) {
    const List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}
