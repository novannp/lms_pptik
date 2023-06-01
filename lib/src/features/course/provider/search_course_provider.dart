import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/features/course/data/course_repository.dart';

import '../../../models/course_model.dart';
import '../../storage/provider/storage_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchCourseProvider =
    FutureProvider.autoDispose<List<CourseModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');

  return Future.delayed(const Duration(milliseconds: 500), () {
    return ref.watch(courseRepositoryProvider).searchCourse(token, query);
  });
});
