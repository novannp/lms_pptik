import 'package:flutter/material.dart';
import 'package:lms_pptik/src/views/themes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  Loading({super.key, this.color});

  Color? color;
  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: color ?? kPrimaryColor,
      size: 30,
    );
  }
}
