import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/badge/provider/get_all_badges.dart';

class BadgeScreen extends ConsumerWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badge = ref.watch(getAllBadgesProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Lencana'),
      ),
      child: badge.when(data: (data) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 1,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final badgeImage = ref.watch(getBadgeImageProvider(data[index]));
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: CupertinoColors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  badgeImage.when(
                      data: (data) {
                        return Image.network(
                          data,
                          width: 50,
                          height: 50,
                        );
                      },
                      error: ((error, stackTrace) => const Text('No Image')),
                      loading: () {
                        return const CupertinoActivityIndicator();
                      }),
                  const SizedBox(height: 10),
                  Text(
                    data[index].name!,
                    textAlign: TextAlign.center,
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                  ),
                ],
              ),
            );
          },
        );
      }, error: (error, stacktrace) {
        return const Center(
          child: Text('Gagal memuat data lencana'),
        );
      }, loading: () {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }),
    );
  }
}
