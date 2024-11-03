import 'package:flutter/material.dart';
import 'dart:math' as math;

abstract class PageViewAnimation {
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      );
}

class GenieAnimation implements PageViewAnimation {
  @override
  Widget buildAnimatedPage(
      BuildContext context,
      Widget Function() builder,
      double currentPage,
      int index,
      ) {
    final double distanceFromCenter = currentPage - index;
    final bool isLeaving = distanceFromCenter > 0;
    final double distance = distanceFromCenter.abs();

    // Calculate transformations based on distance
    final double scale = 1.0 - (0.3 * distance).clamp(0.0, 0.3);
    final double rotate = (math.pi / 8) * distance * (isLeaving ? 1 : -1);

    // Calculate bezier curve control points
    final double verticalTranslation = 100.0 * distance;
    final double horizontalTranslation = 50.0 * distance * (isLeaving ? 1 : -1);

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..translate(horizontalTranslation, verticalTranslation, 0)
        ..scale(scale)
        ..rotateY(rotate),
      alignment: isLeaving ? Alignment.centerRight : Alignment.centerLeft,
      child: Opacity(
        opacity: (1 - (distance * 0.5)).clamp(0.5, 1.0),
        child: builder(),
      ),
    );
  }
}