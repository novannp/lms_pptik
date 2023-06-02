import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lms_pptik/src/extentions/string_extensions.dart';

import '../../models/course_model.dart';
import '../themes.dart';

class CourseCard extends StatelessWidget {
  CourseCard({super.key, required this.course, this.onTap});

  final CourseModel course;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final random = Random();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width - 40,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: flatColor[random.nextInt(8)],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${course.fullname.toString().decodeHtml()} (${course.shortname})',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        course.coursecategory.toString().decodeHtml(),
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                  course.progress != null ? const Spacer() : const SizedBox(),
                  if (course.contact != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          child: Icon(CupertinoIcons.person,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Builder(builder: (context) {
                          if (course.contact!.isEmpty) {
                            return Text(
                              'Tidak ada nama pengajar',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            );
                          }
                          return Row(
                            children: course.contact!
                                .map(
                                  (e) => Text(
                                    ' ${e['fullname'].toString().decodeHtml()} |',
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                )
                                .toList(),
                          );
                        })
                      ],
                    )
                  else
                    const SizedBox(),
                  course.progress != null
                      ? Row(
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
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(color: Colors.white),
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
