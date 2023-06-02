import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lms_pptik/src/features/notification/provider/user_notification.dart';
import 'package:lms_pptik/src/models/user_model.dart';
import 'package:lms_pptik/src/views/themes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/course/provider/enrolled_course_provider.dart';
import '../../features/course/provider/filter_course.dart';
import '../../features/course/provider/recent_course_provider.dart';
import '../../features/notification/data/notification_provider.dart';
import '../../features/user/provider/user_provider.dart';
import '../components/course_card.dart';
import '../components/shimmer_widget.dart';
import '../components/title_widget.dart';
import 'main_screen.dart';

final filterProvider = StateProvider<String>((ref) {
  return 'Baru Saja Diakses';
});

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen(this.tabController, {super.key});
  final CupertinoTabController tabController;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final List _items = [
    {
      'text': 'Baru Saja Diakses',
      'value': 'recent',
    },
    {
      'text': 'Semua Kelas',
      'value': 'all',
    },
    {
      'text': 'Kelas Favorit',
      'value': 'favourites',
    },
    {
      'text': 'Kelas Lalu',
      'value': 'past',
    },
    {
      'text': 'Kelas Aktif',
      'value': 'inprogress',
    },
  ];
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
    // playWelcomeAudio();
  }

  showWelcomeNotification(String name) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        category: NotificationCategory.Email,
        ticker: 'Welcome',
        id: 10,
        channelKey: 'welcome',
        title: 'Hallo! $name',
        body: 'Selamat datang di LMS PPTIK',
      ),
    );
    Future(() {
      final notifierdNotifier = ref.watch(notifiedProvider.notifier);
      notifierdNotifier.state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final selectedFilter = ref.watch(filterCourseProvider);
    final notified = ref.watch(notifiedProvider);
    final notif = ref.watch(userNotificationProvider(user.value!.id as int));

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    widget.tabController.index = 3;
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.when(
                        data: (data) {
                          return data.avatar!;
                        },
                        error: (error, stacktrace) {
                          return 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';
                        },
                        loading: () {
                          return 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    user.when(
                        data: (data) {
                          if (notified) {
                            Future(() {
                              showWelcomeNotification(data.name!);
                              ref.watch(notifiedProvider.notifier).state =
                                  false;
                            });
                          }
                          return Text(
                            data.name!,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .navTitleTextStyle
                                .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                          );
                        },
                        error: (error, stacktrace) {
                          return const Text('User');
                        },
                        loading: () =>
                            const ShimmerWidget(height: 14, width: 100)),
                  ],
                ),
              ]),
            ),
            CupertinoButton(
              onPressed: () {
                GoRouter.of(context).pushNamed('notification',
                    extra: ref.watch(userProvider).value!.id);
              },
              child: Builder(builder: (context) {
                return Badge(
                    label: Text(
                      notif.when(data: (data) {
                        return (data.length.toString());
                      }, error: (error, stacktrace) {
                        return '0';
                      }, loading: () {
                        return '0';
                      }),
                    ),
                    child: const Icon(CupertinoIcons.bell));
              }),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        transitionBetweenRoutes: true,
        border: null,
      ),
      child: CustomScrollView(slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 2)).then((value) {
              ref.refresh(filteredCourseProvider.future);
              ref.refresh(recentCourseProvider.future);
              ref.refresh(userProvider.future);
            });
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed('search');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.search, color: Colors.grey),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Cari Kelas',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.only(
                    left: 10, right: 12, top: 0, bottom: 0),
                child: Column(
                  children: [
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
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildDropdownFilter(String selectedFilter, BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedFilter = ref.watch(filterProvider);
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      cancelButton: CupertinoActionSheetAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Batal'),
                      ),
                      actions: _items
                          .map(
                            (e) => CupertinoActionSheetAction(
                              onPressed: () {
                                ref.read(filterProvider.notifier).state =
                                    e['text'];
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    ref
                                        .watch(filterCourseProvider.notifier)
                                        .state = e['value'];
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: Text(
                                e['text'],
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                );
              },
              child: Text(selectedFilter),
            ),
            Icon(
              CupertinoIcons.chevron_down,
              size: 14,
              color: base6,
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
        return filteredCourse.when(
            skipLoadingOnReload: false,
            skipLoadingOnRefresh: false,
            data: (data) {
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
                                CupertinoIcons.xmark_circle_fill,
                                size: 60,
                                color: Colors.grey.shade300,
                              ),
                              const Text(
                                'Kelas tidak ada',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
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
                                  GoRouter.of(context).pushNamed(
                                      'course_detail',
                                      extra: data[index]);
                                },
                              );
                            },
                          ),
                        ],
                      ),
              );
            },
            error: (error, stackTrace) {
              return const Text('Gagal mendapatkan data');
            },
            loading: () {
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
                          const Text('Tidak ada kelas yang baru dibuka')
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
                              GoRouter.of(context).pushNamed('course_detail',
                                  extra: data[index]);
                            },
                          );
                        },
                      ),
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
