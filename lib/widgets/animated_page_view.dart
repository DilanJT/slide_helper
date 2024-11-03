// lib/widgets/animated_page_view.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

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

class AnimatedPageView extends StatefulWidget {
  final PageController controller;
  final int itemCount;
  final Function(int) onPageChanged;
  final Widget Function(BuildContext, int) itemBuilder;
  final PageViewAnimation animation;

  const AnimatedPageView({
    Key? key,
    required this.controller,
    required this.itemCount,
    required this.onPageChanged,
    required this.itemBuilder,
    required this.animation,
  }) : super(key: key);

  factory AnimatedPageView.fade({
    required PageController controller,
    required int itemCount,
    required Function(int) onPageChanged,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return AnimatedPageView(
      controller: controller,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: itemBuilder,
      animation: PageViewAnimation.fade(),
    );
  }

  factory AnimatedPageView.scale({
    required PageController controller,
    required int itemCount,
    required Function(int) onPageChanged,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return AnimatedPageView(
      controller: controller,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: itemBuilder,
      animation: PageViewAnimation.scale(),
    );
  }

  factory AnimatedPageView.rotation({
    required PageController controller,
    required int itemCount,
    required Function(int) onPageChanged,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return AnimatedPageView(
      controller: controller,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: itemBuilder,
      animation: PageViewAnimation.rotation(),
    );
  }

  factory AnimatedPageView.slide({
    required PageController controller,
    required int itemCount,
    required Function(int) onPageChanged,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return AnimatedPageView(
      controller: controller,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: itemBuilder,
      animation: PageViewAnimation.slide(),
    );
  }

  factory AnimatedPageView.cube({
    required PageController controller,
    required int itemCount,
    required Function(int) onPageChanged,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return AnimatedPageView(
      controller: controller,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: itemBuilder,
      animation: PageViewAnimation.cube(),
    );
  }

  factory AnimatedPageView.flip({
    required PageController controller,
    required int itemCount,
    required Function(int) onPageChanged,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return AnimatedPageView(
      controller: controller,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: itemBuilder,
      animation: PageViewAnimation.flip(),
    );
  }

  factory AnimatedPageView.stack({
    required PageController controller,
    required int itemCount,
    required Function(int) onPageChanged,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return AnimatedPageView(
      controller: controller,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: itemBuilder,
      animation: PageViewAnimation.stack(),
    );
  }

  factory AnimatedPageView.genie({
    required PageController controller,
    required int itemCount,
    required Function(int) onPageChanged,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return AnimatedPageView(
      controller: controller,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: itemBuilder,
      animation: PageViewAnimation.genie(),
    );
  }

  @override
  State<AnimatedPageView> createState() => _AnimatedPageViewState();
}

class _AnimatedPageViewState extends State<AnimatedPageView> {
  late double _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.controller.initialPage.toDouble();
    widget.controller.addListener(_pageListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_pageListener);
    super.dispose();
  }

  void _pageListener() {
    setState(() {
      _currentPage = widget.controller.page ?? widget.controller.initialPage.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.controller,
      itemCount: widget.itemCount,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        return widget.animation.buildAnimatedPage(
          context,
              () => widget.itemBuilder(context, index),
          _currentPage,
          index,
        );
      },
    );
  }
}

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

    // Base transformations
    final double scale = 1.0 - (0.3 * distance).clamp(0.0, 0.3);
    final double rotate = (math.pi / 8) * distance * (isLeaving ? 1 : -1);

    // Bezier curve control points for smooth animation
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double verticalTranslation = screenHeight * 0.1 * distance;
    final double horizontalTranslation = screenWidth * 0.3 * distance * (isLeaving ? 1 : -1);

    // Create genie-like warping effect
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002) // Perspective
        ..translate(
          horizontalTranslation,
          verticalTranslation * (1 - distance).clamp(0.0, 1.0),
          0,
        )
        ..scale(
          scale,
          1.0 - (distance * 0.2).clamp(0.0, 0.2),
          1.0,
        )
        ..rotateY(rotate),
      alignment: isLeaving ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(distance * 20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(distance * 20),
          child: Opacity(
            opacity: (1 - (distance * 0.5)).clamp(0.5, 1.0),
            child: builder(),
          ),
        ),
      ),
    );
  }
}