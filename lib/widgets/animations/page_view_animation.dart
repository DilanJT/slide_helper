import 'package:flutter/material.dart';
import 'basic_animations.dart';
import 'genie_animation.dart';

abstract class PageViewAnimation {
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      );

  factory PageViewAnimation.fade() = FadeAnimation;
  factory PageViewAnimation.scale() = ScaleAnimation;
  factory PageViewAnimation.rotation() = RotationAnimation;
  factory PageViewAnimation.slide() = SlideAnimation;
  factory PageViewAnimation.cube() = CubeAnimation;
  factory PageViewAnimation.flip() = FlipAnimation;
  factory PageViewAnimation.stack() = StackAnimation;
  factory PageViewAnimation.genie() = GenieAnimation;
}