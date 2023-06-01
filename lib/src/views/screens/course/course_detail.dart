import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_pptik/src/extentions/date_time_extension.dart';
import 'package:lms_pptik/src/extentions/string_extensions.dart';
import 'package:lms_pptik/src/views/screens/dashboard_screen.dart';

import '../../../features/course/provider/detail_course_provider.dart';
import '../../../features/course/provider/enrolled_course_users_provider.dart';
import '../../../features/course/provider/recent_course_provider.dart';
import '../../../models/course_model.dart';
import '../../../models/module.dart';
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

class _CourseDetailState extends ConsumerState<CourseDetail>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(tabIndexProvider);
    return WillPopScope(
      onWillPop: () {
        ref.refresh(recentCourseProvider.future);
        return Future.value(true);
      },
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: tabIndex == 0,
          child: FloatingActionButton(
            tooltip: 'Tampilkan list materi',
            onPressed: () {},
            child: const Icon(FluentIcons.list_28_regular),
          ),
        ),
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              CourseCard(course: widget.course),
              const SizedBox(height: 10),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                  onTap: (value) {
                    ref.watch(tabIndexProvider.notifier).state = value;
                  },
                  padding: const EdgeInsets.all(8),
                  indicator: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                  unselectedLabelColor: Colors.grey.shade500,
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                  labelColor: Colors.black,
                  isScrollable: true,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Materi'),
                    Tab(text: 'Peserta'),
                    Tab(text: 'Nilai'),
                    Tab(text: 'Kompetensi'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        Materi(widget.course.id!),
                      ],
                    ),
                    Container(
                      child: Member(widget.course.id!),
                    ),
                    Container(
                      child: const Value(),
                    ),
                    Container(
                      child: const Competention(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
