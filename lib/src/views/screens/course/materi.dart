part of 'course_detail.dart';

class Materi extends ConsumerWidget {
  const Materi(this.id, {super.key});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materi = ref.watch(materiProvider(id));
    return materi.when(
        data: (data) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.doc),
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed('materi_detail', extra: data[index]);
                    },
                    title: Text(
                      data[index].name!.decodeHtml(),
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                            color: Colors.black,
                          ),
                    ),
                  )
                ],
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Text(error.toString());
        },
        loading: () => const Loading());
  }
}
