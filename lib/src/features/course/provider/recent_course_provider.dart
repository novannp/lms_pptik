import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/course_model.dart';
import '../../storage/provider/storage_provider.dart';
import '../data/course_repository.dart';

final recentCourseProvider =
    FutureProvider.autoDispose<List<CourseModel>>((ref) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  return ref.watch(courseRepositoryProvider).getRecentCourses(token);
});
