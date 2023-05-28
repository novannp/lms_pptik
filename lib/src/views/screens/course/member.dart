part of 'course_detail.dart';

class Member extends ConsumerWidget {
  const Member(this.courseId, {super.key});
  final int courseId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userList = ref.watch(enrolledCourseUsersProvider(courseId));
    return userList.when(data: (data) {
      return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {},
              leading: CircleAvatar(
                backgroundImage: NetworkImage(data[index].avatar.toString()),
              ),
              title: Text(data[index].name.toString()),
              subtitle: Text.rich(
                TextSpan(
                    text: 'Terakhir akses: ',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: DateTime.fromMillisecondsSinceEpoch(
                                  data[index].lastCourseAccess! * 1000)
                              .formatDate(),
                          style: Theme.of(context).textTheme.labelMedium)
                    ]),
              ),
            );
          },
          itemCount: data.length);
    }, error: (error, stackTrace) {
      return Container();
    }, loading: () {
      return Loading();
    });
  }
}
