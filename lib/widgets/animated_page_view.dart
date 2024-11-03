

import 'package:flutter/material.dart';
import 'package:slide_helper/widgets/page_view_animation.dart';

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