import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/course/provider/recent_course_provider.dart';
import '../components/course_card.dart';

class RecentCourseScreen extends ConsumerWidget {
  const RecentCourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentCourse = ref.watch(recentCourseProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Kelas Baru Ini'),
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      body: recentCourse.when(
        data: (data) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return CourseCard(
                course: data[index],
              );
            },
          );
        },
        error: (error, stackTrace) {},
        loading: () {},
      ),
    );
  }
}
