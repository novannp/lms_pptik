import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';
import 'package:lms_pptik/src/features/http/provider/http_provider.dart';

import '../../../models/user_model.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(httpProvider));
});

class UserRepository {
  final IOClient client;

  UserRepository(this.client);

  Future<UserModel> getUser(String username, String token) async {
    String baseUrl =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_user_get_users_by_field&moodlewsrestformat=json&field=username&values[]=$username";

    Uri url = Uri.parse(baseUrl);
    final response = await client.get(url);
    final result = jsonDecode(response.body);
    inspect(result);
    if (response.statusCode == 200) {
      return UserModel.fromJson(result[0]);
    } else {
      throw Exception();
    }
  }
}
