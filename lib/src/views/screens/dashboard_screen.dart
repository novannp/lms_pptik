import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lms_pptik/src/extentions/int_extensions.dart';
import 'package:lms_pptik/src/extentions/string_extensions.dart';
import 'package:lms_pptik/src/views/themes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/course/provider/enrolled_course_provider.dart';
import '../../features/course/provider/filter_course.dart';
import '../../features/course/provider/recent_course_provider.dart';
import '../../features/user/provider/user_provider.dart';
import '../../models/course_model.dart';
import '../components/title_widget.dart';
import 'main_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void playWelcomeAudio() async {
    final player = AudioPlayer();
    await player.setAsset('assets/audio/Selamat Datang.mp3');
    player.play();
  }

  @override
  void initState() {
    super.initState();
    playWelcomeAudio();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final selectedFilter = ref.watch(filterCourseProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: user.when(data: (data) {
        return AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          leadingWidth: 0,
          actions: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        FluentIcons.alert_20_regular,
                        color: base6,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.watch(indexProvider.notifier).state = 3;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data.avatar!),
                    ),
                  ),
                ),
              ],
            )
          ],
          titleTextStyle: const TextStyle(color: Colors.black),
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LMS PPTIK',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(height: 12),
                    Text(data.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall)
                  ],
                ),
              ],
            ),
          ),
        );
      }, error: (error, stacktrace) {
        return appBarError(context);
      }, loading: () {
        return appBarLoading();
      }),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2), () {
            // ref.refresh(enrolledCourseProvider.future);
            ref.refresh(recentCourseProvider.future);
            ref.refresh(userProvider.future);
          });

          _refreshController.refreshCompleted();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    GoRouter.of(context).pushNamed('search');
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: const [
                        Icon(Icons.search),
                        SizedBox(width: 10),
                        Text('Cari kelas'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TitleWidget(text: 'Kelas Saya'),
                  buildDropdownFilter(selectedFilter, context),
                ],
              ),
              const SizedBox(height: 12),
              selectedFilter == 'recent'
                  ? buildRecentCourses()
                  : buildCoursesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdownFilter(String selectedFilter, BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton(
              value: selectedFilter,
              underline: Container(),
              iconSize: 18,
              hint: const Text('Baru saja diakses'),
              style: Theme.of(context).textTheme.titleSmall,
              elevation: 0,
              icon: const Icon(FluentIcons.chevron_down_20_regular),
              isDense: true,
              items: const [
                DropdownMenuItem(
                  value: 'recent',
                  child: Text('Baru saja diakses'),
                ),
                DropdownMenuItem(
                  value: 'all',
                  child: Text('Semua kelas'),
                ),
                DropdownMenuItem(
                  value: 'inprogress',
                  child: Text('Dalam progress'),
                ),
                DropdownMenuItem(
                  value: 'past',
                  child: Text('Kelas lalu'),
                ),
                DropdownMenuItem(
                  value: 'favourites',
                  child: Text('Kelas Favorit'),
                ),
              ],
              onChanged: (value) {
                ref.watch(filterCourseProvider.notifier).state =
                    value.toString();
                ref.refresh(filteredCourseProvider);
              },
            ),
          ],
        );
      },
    );
  }

  Consumer buildCoursesList() {
    return Consumer(
      builder: (context, ref, child) {
        final filteredCourse = ref.watch(filteredCourseProvider);
        return filteredCourse.when(data: (data) {
          return SizedBox(
            child: data.isEmpty
                ? Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: borderColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.subtitles_off_outlined,
                            size: 60,
                            color: Colors.grey.shade300,
                          ),
                          const Text('Kelas tidak ada')
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return CourseCard(
                            course: data[index],
                            onTap: () {
                              GoRouter.of(context)
                                  .pushNamed('course_detail', extra: e);
                            },
                          );
                        },
                      ),
                    ],
                  ),
          );
        }, error: (error, stackTrace) {
          return const Text('Gagal mendapatkan data');
        }, loading: () {
          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ShimmerWidget(height: 14, width: 100),
                const SizedBox(height: 10),
                ShimmerWidget(
                    height: 150, width: MediaQuery.of(context).size.width)
              ],
            ),
          );
        });
      },
    );
  }

  Consumer buildRecentCourses() {
    return Consumer(
      builder: (context, ref, child) {
        final recentCourse = ref.watch(recentCourseProvider);
        return recentCourse.when(data: (data) {
          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                data.isEmpty
                    ? Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.subtitles_off_outlined,
                                size: 60,
                                color: Colors.grey.shade300,
                              ),
                              const Text('Tidak ada kelas yang baru dibuka')
                            ],
                          ),
                        ),
                      )
                    : CourseCard(
                        course: data[0],
                        onTap: () {
                          GoRouter.of(context)
                              .pushNamed('course_detail', extra: data[0]);
                        },
                      )
              ],
            ),
          );
        }, error: (error, stackTrace) {
          return Text(error.toString());
        }, loading: () {
          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ShimmerWidget(height: 14, width: 100),
                const SizedBox(height: 10),
                ShimmerWidget(
                    height: 150, width: MediaQuery.of(context).size.width)
              ],
            ),
          );
        });
      },
    );
  }

  AppBar appBarLoading() {
    return AppBar(
      actions: [
        Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade300,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: ShimmerWidget(
                height: 40,
                width: 40,
              ),
            ),
          ],
        )
      ],
      elevation: 0,
      toolbarHeight: 80,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade300,
              child: Container(
                height: 14,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade300,
              child: Container(
                height: 14,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

AppBar appBarError(BuildContext context) {
  return AppBar(
    actions: [
      Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  FluentIcons.alert_24_regular,
                  color: base6,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        ],
      )
    ],
    elevation: 0,
    toolbarHeight: 80,
    title: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LMS PPTIK',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Halo, ',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 12),
              Text('',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall)
            ],
          ),
        ],
      ),
    ),
  );
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
  });
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  CourseCard({super.key, required this.course, this.onTap});

  final CourseModel course;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final _random = Random();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width - 40,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: flatColor[_random.nextInt(8)],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                width: 120,
                fit: BoxFit.fitHeight,
                alignment: Alignment.bottomRight,
                'assets/images/course_bg.svg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${course.fullname.toString().decodeHtml()} (${course.shortname})' ??
                        '',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    course.coursecategory.toString().decodeHtml(),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black.withOpacity(0.2),
                          color: Colors.white,
                          value: course.progress! / 100,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${course.progress}% Selesai',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
