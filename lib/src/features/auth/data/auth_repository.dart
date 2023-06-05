import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../../../utills/endpoints.dart';
import '../../http/provider/http_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(httpProvider);
  return AuthRepository(client: client);
});

class AuthRepository {
  final IOClient client;

  AuthRepository({required this.client});

  Future login(String username, String password) async {
    Uri url = Uri.https(Endpoints.baseUrl, Endpoints.login, {
      'service': 'moodle_mobile_app',
      'username': username,
      'password': password,
    });

    final response = await client.get(url);
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception();
    }
  }
}
