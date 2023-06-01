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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        titleTextStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                        leading: const Icon(FluentIcons.document_28_regular),
                        onTap: () {
                          GoRouter.of(context)
                              .pushNamed('materi_detail', extra: data[index]);
                        },
                        title: Text(data[index].name!.decodeHtml()),
                      )
                    ],
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
