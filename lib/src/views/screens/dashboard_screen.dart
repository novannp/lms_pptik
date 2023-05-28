import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lms_pptik/src/extentions/string_extensions.dart';
import 'package:lms_pptik/src/views/components/loading_widget.dart';
import 'package:lms_pptik/src/views/themes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/course/provider/enrolled_course_provider.dart';
import '../../features/course/provider/recent_course_provider.dart';
import '../../features/user/provider/user_provider.dart';
import '../../models/course_model.dart';
import '../components/title_widget.dart';

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
                        Icons.notifications,
                        color: base6,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data.avatar!),
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
            ref.refresh(enrolledCourseProvider.future);
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
                  onTap: () {},
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
              Consumer(
                builder: (context, ref, child) {
                  final recentCourse = ref.watch(recentCourseProvider);
                  return recentCourse.when(data: (data) {
                    return SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const TitleWidget(text: 'Course Baru ini'),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.subtitles_off_outlined,
                                          size: 60,
                                          color: Colors.grey.shade300,
                                        ),
                                        const Text(
                                            'Tidak ada kelas yang baru dibuka')
                                      ],
                                    ),
                                  ),
                                )
                              : CourseCard(
                                  course: data[0],
                                  onTap: () {
                                    GoRouter.of(context).pushNamed(
                                        'course_detail',
                                        extra: data[0]);
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
                              height: 150,
                              width: MediaQuery.of(context).size.width)
                        ],
                      ),
                    );
                  });
                },
              ),
              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, child) {
                  final recentCourse = ref.watch(enrolledCourseProvider);
                  return recentCourse.when(data: (data) {
                    return SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const TitleWidget(text: 'Course Terdaftar'),
                          const SizedBox(height: 10),
                          Column(
                            children: data.isEmpty
                                ? [
                                    Container(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.subtitles_off_outlined,
                                              size: 60,
                                              color: Colors.grey.shade300,
                                            ),
                                            const Text(
                                                'Tidak ada kelas yang terdaftar')
                                          ],
                                        ),
                                      ),
                                    )
                                  ]
                                : data
                                    .map((e) => CourseCard(
                                          course: e,
                                          onTap: () {
                                            GoRouter.of(context).pushNamed(
                                                'course_detail',
                                                extra: e);
                                          },
                                        ))
                                    .toList(),
                          )
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
                              height: 150,
                              width: MediaQuery.of(context).size.width)
                        ],
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
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
                  Icons.notifications,
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
            Positioned(
              bottom: -35,
              left: 30,
              height: 150,
              child: SvgPicture.asset(
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
