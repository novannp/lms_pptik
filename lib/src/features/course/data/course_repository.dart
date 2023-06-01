import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';
import 'package:lms_pptik/src/features/http/provider/http_provider.dart';

import '../../../models/course_model.dart';
import '../../../models/module.dart';
import '../../../models/user_model.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(ref.watch(httpProvider));
});

class CourseRepository {
  final IOClient client;

  CourseRepository(this.client);

  Future<List<CourseModel>> getRecentCourses(String token) async {
    String baseUrl =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_course_get_recent_courses&moodlewsrestformat=json";

    Uri url = Uri.parse(baseUrl);
    final response = await client.get(url);
    final result = jsonDecode(response.body);
    inspect(result);
    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <CourseModel>[];
      }
      return result.map<CourseModel>((e) => CourseModel.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }

  Future<List<CourseModel>> getFilteredCourse(
      String token, String category) async {
    String baseUrl =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_course_get_enrolled_courses_by_timeline_classification&moodlewsrestformat=json&classification=$category";

    Uri url = Uri.parse(baseUrl);
    final response = await client.get(url);
    final List result = jsonDecode(response.body)['courses'] as List;
    inspect(result);
    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <CourseModel>[];
      }
      return result.map((e) => CourseModel.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }

  Future<List<MateriModel>> getMateriCourse(String token, int courseId) async {
    String baseUrl =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_course_get_contents&moodlewsrestformat=json&courseid=$courseId";
    String viewUrl =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_course_view_course&moodlewsrestformat=json&courseid=$courseId";
    Uri url = Uri.parse(baseUrl);
    Uri viewUri = Uri.parse(viewUrl);
    final responseView = await client.get(viewUri);

    final response = await client.get(url);
    final List result = jsonDecode(response.body) as List;
    inspect(result);
    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <MateriModel>[];
      }
      return result.map((e) => MateriModel.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }

  Future<List<UserModel>> getEnrolledUsers(String token, int courseId) async {
    String baseUrl =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_enrol_get_enrolled_users&moodlewsrestformat=json&courseid=$courseId";

    Uri url = Uri.parse(baseUrl);
    final response = await client.get(url);
    final List result = jsonDecode(response.body) as List;
    inspect(result);
    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <UserModel>[];
      }
      return result.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }

  Future<List<CourseModel>> searchCourse(String token, String query) async {
    String baseUrl =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_course_search_courses&moodlewsrestformat=json&criterianame=search&criteriavalue=$query";

    Uri url = Uri.parse(baseUrl);
    final response = await client.get(url);
    final List result = jsonDecode(response.body)['courses'] as List;
    inspect(result);
    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <CourseModel>[];
      }
      return result.map((e) => CourseModel.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }
}
