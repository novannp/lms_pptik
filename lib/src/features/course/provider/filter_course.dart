import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterCourseProvider = StateProvider<String>((ref) {
  return 'all';
});
