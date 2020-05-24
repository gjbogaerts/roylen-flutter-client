import 'package:intl/intl.dart';

class DateString {
  static String convert(String mongoDate) {
    return DateFormat.yMEd()
        .addPattern("H:m")
        .format(DateTime.parse(mongoDate));
  }
}
