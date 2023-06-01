import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/event_model.dart';
import '../../storage/provider/storage_provider.dart';
import '../data/calendar_repository.dart';

final allEventProvider = FutureProvider<List<EventModel>>((ref) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  return ref.watch(calendarProvider).getAllEvent(token);
});
