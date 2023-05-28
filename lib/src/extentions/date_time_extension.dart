import 'package:intl/intl.dart';

extension DateTimeExtention on DateTime {
  String formatDate() {
    final format = DateFormat("dd MMMM yyyy, HH:mm");
    final formattedDate = format.format(this);
    return formattedDate;
  }
}
