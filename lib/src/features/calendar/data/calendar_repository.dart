import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../../../models/event_model.dart';
import '../../http/provider/http_provider.dart';
import '../provider/all_events_provider.dart';

final calendarProvider = Provider<CalendarRepository>((ref) {
  final http = ref.watch(httpProvider);
  return CalendarRepository(http);
});

class CalendarRepository {
  final IOClient client;

  CalendarRepository(this.client);

  Future<List<EventModel>> getAllEvent(String token) async {
    String baseUrl =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_calendar_get_calendar_events&moodlewsrestformat=json";

    Uri url = Uri.parse(baseUrl);
    final response = await client.get(url);
    final result = jsonDecode(response.body)['events'];
    inspect(result);
    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <EventModel>[];
      }
      return result.map<EventModel>((e) => EventModel.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }
}
