/// Formats [time] as "hh:mm AM/PM" (e.g. "09:05 AM", "11:00 PM").
///
/// Returns "--:--" when [time] is null (the API did not send a valid time).
String formatTime12h(DateTime? time) {
  if (time == null) return '--:--';

  final period = time.hour < 12 ? 'AM' : 'PM';
  // 0 and 12 are shown as 12 (12:05 AM is just after midnight).
  final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final hour = hour12.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');

  return '$hour:$minute $period';
}
