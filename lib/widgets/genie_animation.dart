import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:slide_helper/widgets/page_view_animation.dart';

class GenieAnimation implements PageViewAnimation {
  @override
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      ) {
    final double distance = (currentPage - index).abs();
    final double scale = 1.0 - (distance * 0.3).clamp(0.0, 0.3);
    final double angle = distance * math.pi / 2;

    return Transform(
      alignment: distance > 0 ? Alignment.centerRight : Alignment.centerLeft,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..scale(scale, 1.0, 1.0)
        ..rotateY(angle),
      child: builder(),
    );
  }
}