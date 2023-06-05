import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';
import 'package:lms_pptik/src/features/http/provider/http_provider.dart';
import 'package:lms_pptik/src/views/themes.dart';

import '../../../models/course_model.dart';
import '../../../models/module.dart';
import '../../../models/user_model.dart';
import '../../../utills/endpoints.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(ref.watch(httpProvider));
});

class CourseRepository {
  final IOClient client;

  CourseRepository(this.client);

  Future<List<CourseModel>> getRecentCourses(String token) async {
    Uri url = Uri.https(Endpoints.baseUrl, Endpoints.rest, {
      'wstoken': token,
      'wsfunction': 'core_course_get_recent_courses',
      'moodlewsrestformat': 'json',
    });
    final response = await client.get(url);
    final result = jsonDecode(response.body);
    inspect(result);
    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <CourseModel>[];
      }
      return result
          .map<CourseModel>(
              (e) => CourseModel.fromJson(e, flatColor[Random().nextInt(7)]))
          .toList();
    } else {
      throw Exception();
    }
  }

  Future<List<CourseModel>> getFilteredCourse(
      String token, String category) async {
    Uri url = Uri.https(Endpoints.baseUrl, Endpoints.rest, {
      'wstoken': token,
      'wsfunction':
          'core_course_get_enrolled_courses_by_timeline_classification',
      'moodlewsrestformat': 'json',
      'classification': category,
    });

    final response = await client.get(url);

    final List result = jsonDecode(response.body)['courses'] as List;

    inspect(result);

    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <CourseModel>[];
      }
      return result
          .map((e) => CourseModel.fromJson(e, flatColor[Random().nextInt(7)]))
          .toList();
    } else {
      throw Exception();
    }
  }

  Future<List<MateriModel>> getMateriCourse(String token, int courseId) async {
    Uri url = Uri.https(
      Endpoints.baseUrl,
      Endpoints.rest,
      {
        'wstoken': token,
        'wsfunction': 'core_course_get_contents',
        'moodlewsrestformat': 'json',
        'courseid': courseId,
      }.map((key, value) => MapEntry(key, value.toString())),
    );

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
    Uri url = Uri.https(
      Endpoints.baseUrl,
      Endpoints.rest,
      {
        'wstoken': token,
        'wsfunction': 'core_enrol_get_enrolled_users',
        'moodlewsrestformat': 'json',
        'courseid': courseId,
      }.map((key, value) => MapEntry(key, value.toString())),
    );
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
    Uri url = Uri.https(Endpoints.baseUrl, Endpoints.rest, {
      'wstoken': token,
      'wsfunction': 'core_course_search_courses',
      'moodlewsrestformat': 'json',
      'criterianame': 'search',
      'criteriavalue': query,
    });

    final response = await client.get(url);

    final List result = jsonDecode(response.body)['courses'] as List;

    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <CourseModel>[];
      }
      return result
          .map((e) => CourseModel.fromJson(e, flatColor[Random().nextInt(7)]))
          .toList();
    } else {
      throw Exception();
    }
  }

  Future addCourseToFavorite(String token, int courseId) async {
    Uri url = Uri.https(Endpoints.baseUrl, Endpoints.rest, {
      'wstoken': token,
      'wsfunction': 'core_course_set_favourite_courses',
      'moodlewsrestformat': 'json',
      'courseid': courseId,
    });

    final response = await client.get(url);
    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (result['status'] == 'ok') {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception();
    }
  }
}
