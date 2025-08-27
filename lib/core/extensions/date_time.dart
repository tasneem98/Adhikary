extension DateTimeExtension on DateTime {
  String get toHourMinuteSecond12Format =>
      '${hour > 12 ? (hour - 12).toString().padLeft(2, '0') : hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')} ${hour > 12 ? 'PM' : 'AM'}';
}
