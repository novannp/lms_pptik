extension IntExtension on int {
  DateTime toDate() {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }
}
