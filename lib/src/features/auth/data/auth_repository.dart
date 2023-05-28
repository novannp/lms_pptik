import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../../http/provider/http_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(httpProvider);
  return AuthRepository(client: client);
});

class AuthRepository {
  final IOClient client;

  AuthRepository({required this.client});

  Future login(String username, String password) async {
    password = Uri.encodeComponent(password);
    String baseUrl =
        "https://lms.pptik.id/login/token.php?service=moodle_mobile_app&username=$username&password=$password";

    Uri url = Uri.parse(baseUrl);
    log(baseUrl);
    final response = await client.get(url);
    final result = jsonDecode(response.body);
    inspect(result);
    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception();
    }
  }
}
