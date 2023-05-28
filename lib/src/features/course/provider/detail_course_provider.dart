import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/module.dart';
import '../../storage/provider/storage_provider.dart';
import '../data/course_repository.dart';

final materiProvider =
    FutureProvider.family<List<MateriModel>, int>((ref, courseId) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  return ref.watch(courseRepositoryProvider).getMateriCourse(token, courseId);
});
