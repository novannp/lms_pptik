import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../../../models/badge_model.dart';
import '../../../utills/endpoints.dart';
import '../../http/provider/http_provider.dart';

final badgeRepositoryProvider = Provider<BadgeRepository>((ref) {
  return BadgeRepository(ref.watch(httpProvider));
});

class BadgeRepository {
  final IOClient client;

  BadgeRepository(this.client);

  Future<List<BadgeModel>> getBadges(String token) async {
    final url = Uri.https(Endpoints.baseUrl, Endpoints.rest, {
      'wstoken': token,
      'wsfunction': 'core_badges_get_user_badges',
      'moodlewsrestformat': 'json',
    });
    final response = await client.get(url);
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return <BadgeModel>[];
      }
      final result = jsonDecode(response.body)['badges'];

      return result.map<BadgeModel>((e) => BadgeModel.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }

  Future<String> getBadgeImage(String token, BadgeModel badge) async {
    return ('${badge.badgeurl!}?token=$token');
  }
}
