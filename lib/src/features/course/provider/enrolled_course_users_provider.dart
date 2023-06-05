import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../../storage/provider/storage_provider.dart';
import '../data/course_repository.dart';

final enrolledCourseUsersProvider = FutureProvider.family
    .autoDispose<List<UserModel>, int>((ref, courseId) async {
  final token = await ref.watch(storageProvider).read('token');
  return ref.watch(courseRepositoryProvider).getEnrolledUsers(token, courseId);
});
