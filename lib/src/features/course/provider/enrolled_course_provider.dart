import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/features/course/data/course_repository.dart';
import 'package:lms_pptik/src/features/storage/provider/storage_provider.dart';

import '../../../models/course_model.dart';
import 'filter_course.dart';

final filteredCourseProvider =
    FutureProvider.autoDispose<List<CourseModel>>((ref) async {
  final token = await ref.watch(storageProvider).read('token');
  return ref
      .watch(courseRepositoryProvider)
      .getFilteredCourse(token, ref.watch(filterCourseProvider));
});
