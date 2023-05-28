part of 'course_detail.dart';

class Materi extends ConsumerWidget {
  const Materi(this.id, {super.key});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materi = ref.watch(materiProvider(id));
    return materi.when(
        data: (data) {
          return Expanded(
            child: Container(
              padding:
                  const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[100]!),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HtmlWidget(data[index].summary!),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data[index].modules!.length,
                          itemBuilder: (context, i) {
                            final mod = data[index].modules![i];
                            switch (mod.modplural) {
                              case 'Forums':
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade100,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: SvgPicture.asset(
                                      height: 40,
                                      'assets/icons/news.svg',
                                    ),
                                    title: Text(
                                      mod.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ),
                                );
                              case 'Quizzes':
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade100,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: SvgPicture.asset(
                                          height: 40,
                                          'assets/icons/tick-box.svg',
                                        ),
                                        title: Text(
                                          mod.name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          border: Border.all(
                                            color: Colors.grey.shade100,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_month,
                                                    size: 20),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'Dibuka: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    children: [
                                                      TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium,
                                                        text: DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    mod.dates![0]
                                                                            [
                                                                            'timestamp']! *
                                                                        1000)
                                                            .toString()
                                                            .formatDate(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_month,
                                                    size: 20),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'Ditutup: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    children: [
                                                      TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium,
                                                        text: DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    mod.dates![1]
                                                                            [
                                                                            'timestamp']! *
                                                                        1000)
                                                            .toString()
                                                            .formatDate(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              case 'Labels':
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade100,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mod.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 25,
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Tandai Selesai',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              case 'Workshops':
                                return Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: !mod.completiondata!['uservisible']
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade100,
                                    border: Border.all(
                                      color: Colors.grey.shade100,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: SvgPicture.asset(
                                          height: 40,
                                          'assets/icons/speech-bubble.svg',
                                        ),
                                        title: Text(
                                          mod.name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                        trailing:
                                            !mod.completiondata!['uservisible']
                                                ? Icon(Icons.lock)
                                                : null,
                                        subtitle:
                                            !mod.completiondata!['uservisible']
                                                ? null
                                                : SizedBox(
                                                    height: 25,
                                                    width: 100,
                                                    child: OutlinedButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        'Tandai Selesai',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall,
                                                      ),
                                                    ),
                                                  ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: !mod.completiondata![
                                                  'uservisible']
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade100,
                                          border: Border.all(
                                            color: Colors.grey.shade100,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_month,
                                                    size: 20),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'Pengiriman dibuka: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    children: [
                                                      TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium,
                                                        text: DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    mod.dates![0]
                                                                            [
                                                                            'timestamp']! *
                                                                        1000)
                                                            .toString()
                                                            .formatDate(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_month,
                                                    size: 20),
                                                Text.rich(
                                                  TextSpan(
                                                    text:
                                                        'Pengiriman ditutup: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    children: [
                                                      TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium,
                                                        text: DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    mod.dates![1]
                                                                            [
                                                                            'timestamp']! *
                                                                        1000)
                                                            .toString()
                                                            .formatDate(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_month,
                                                    size: 20),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'Penilaian dibuka: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    children: [
                                                      TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium,
                                                        text: DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    mod.dates![1]
                                                                            [
                                                                            'timestamp']! *
                                                                        1000)
                                                            .toString()
                                                            .formatDate(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_month,
                                                    size: 20),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'Penilaian ditutup: ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    children: [
                                                      TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium,
                                                        text: DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                                    mod.dates![1]
                                                                            [
                                                                            'timestamp']! *
                                                                        1000)
                                                            .toString()
                                                            .formatDate(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              default:
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Text(error.toString());
        },
        loading: () => Loading());
  }
}
