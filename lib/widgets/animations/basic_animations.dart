// lib/widgets/animations/basic_animations.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'page_view_animation.dart';

class FadeAnimation implements PageViewAnimation {
  @override
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      ) {
    final double opacity = 1.0 - (currentPage - index).abs();
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: builder(),
    );
  }
}

class ScaleAnimation implements PageViewAnimation {
  @override
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      ) {
    final double scale = 1.0 - ((currentPage - index).abs() * 0.2).clamp(0.0, 0.2);
    return Transform.scale(
      scale: scale,
      child: builder(),
    );
  }
}

class RotationAnimation implements PageViewAnimation {
  @override
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      ) {
    final double angle = (currentPage - index) * math.pi / 4;
    return Transform.rotate(
      angle: angle,
      child: builder(),
    );
  }
}

class SlideAnimation implements PageViewAnimation {
  @override
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      ) {
    final double offset = (currentPage - index) * MediaQuery.of(context).size.width;
    return Transform.translate(
      offset: Offset(0, offset * 0.2),
      child: builder(),
    );
  }
}

class CubeAnimation implements PageViewAnimation {
  @override
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      ) {
    final double angle = (currentPage - index) * math.pi / 2;
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle),
      alignment: Alignment.center,
      child: builder(),
    );
  }
}

class FlipAnimation implements PageViewAnimation {
  @override
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      ) {
    final double angle = (currentPage - index) * math.pi;
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(angle),
      alignment: Alignment.center,
      child: builder(),
    );
  }
}

class StackAnimation implements PageViewAnimation {
  @override
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      ) {
    final double scale = 1.0 - ((currentPage - index).abs() * 0.1);
    final double translate = (currentPage - index) * MediaQuery.of(context).size.width * 0.85;
    return Transform(
      transform: Matrix4.identity()
        ..translate(translate)
        ..scale(scale),
      child: builder(),
    );
  }
}