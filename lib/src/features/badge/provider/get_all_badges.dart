import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/badge_model.dart';
import '../../storage/provider/storage_provider.dart';
import '../data/badge_repository.dart';

final getAllBadgesProvider = FutureProvider<List<BadgeModel>>((ref) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  return ref.watch(badgeRepositoryProvider).getBadges(token);
});

final getBadgeImageProvider =
    FutureProvider.family<String, BadgeModel>((ref, badge) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  return ref.watch(badgeRepositoryProvider).getBadgeImage(token, badge);
});
