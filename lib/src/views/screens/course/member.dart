part of 'course_detail.dart';

class Member extends ConsumerWidget {
  const Member(this.courseId, {super.key});
  final int courseId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userList = ref.watch(enrolledCourseUsersProvider(courseId));
    return userList.when(data: (data) {
      return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return CupertinoListTile(
              additionalInfo: Text(
                data[index].city ?? '-',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
              ),
              onTap: () {},
              leadingSize: 44,
              padding: const EdgeInsets.all(0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(data[index].avatar.toString()),
              ),
              title: Text(
                data[index].name.toString(),
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
              subtitle: Text.rich(
                TextSpan(
                    text: 'Terakhir akses: ',
                    style:
                        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                    children: [
                      TextSpan(
                          text: DateTime.fromMillisecondsSinceEpoch(
                                  data[index].lastCourseAccess! * 1000)
                              .formatDate(),
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ))
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
