
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_pptik/src/extentions/date_time_extension.dart';
import 'package:lms_pptik/src/extentions/string_extensions.dart';

import '../../../features/course/provider/detail_course_provider.dart';
import '../../../features/course/provider/enrolled_course_users_provider.dart';
import '../../../features/course/provider/recent_course_provider.dart';
import '../../../models/course_model.dart';
import '../../components/course_card.dart';
import '../../components/loading_widget.dart';
part 'materi.dart';
part 'member.dart';
part 'competention.dart';
part 'value.dart';

final tabIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class CourseDetail extends ConsumerStatefulWidget {
  final CourseModel course;
  const CourseDetail(this.course, {super.key});

  @override
  ConsumerState<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends ConsumerState<CourseDetail> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(tabIndexProvider);
    return WillPopScope(
      onWillPop: () {
        ref.refresh(recentCourseProvider.future);
        return Future.value(true);
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.grey.shade50,
          middle: Text(widget.course.fullname!.decodeHtml()),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
            child: Column(
              children: [
                CourseCard(course: widget.course),
                const SizedBox(height: 10),
                CupertinoSlidingSegmentedControl(
                  backgroundColor: Colors.grey.shade200,
                  thumbColor: Colors.white,
                  groupValue: tabIndex,
                  children: {
                    0: buildSegment(context, 'Materi'),
                    1: buildSegment(context, 'Peserta'),
                    2: buildSegment(context, 'Kompetensi'),
                    3: buildSegment(context, 'Nilai'),
                  },
                  onValueChanged: (value) {
                    ref.read(tabIndexProvider.notifier).state = value as int;
                  },
                ),
                Expanded(
                  child: IndexedStack(
                    index: tabIndex,
                    children: [
                      Materi(widget.course.id!),
                      Member(widget.course.id!),
                      const Value(),
                      const Competention(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildSegment(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: CupertinoTheme.of(context)
            .textTheme
            .textStyle
            .copyWith(color: Colors.black),
      ),
    );
  }
}
