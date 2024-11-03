import 'package:flutter/material.dart';
import 'dart:io';
import '../models/project.dart';
import '../widgets/animated_page_view.dart';

enum SlideAnimation {
  fade,
  scale,
  rotation,
  slide,
  cube,
  flip,
  stack
}

class ImageSlideshowScreen extends StatefulWidget {
  final Project project;

  const ImageSlideshowScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  _ImageSlideshowScreenState createState() => _ImageSlideshowScreenState();
}

class _ImageSlideshowScreenState extends State<ImageSlideshowScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  SlideAnimation _currentAnimation = SlideAnimation.fade;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPageView() {
    switch (_currentAnimation) {
      case SlideAnimation.fade:
        return AnimatedPageView.fade(
          controller: _pageController,
          itemCount: widget.project.images.length,
          onPageChanged: _handlePageChanged,
          itemBuilder: _buildAnimatedPage,
        );
      case SlideAnimation.scale:
        return AnimatedPageView.scale(
          controller: _pageController,
          itemCount: widget.project.images.length,
          onPageChanged: _handlePageChanged,
          itemBuilder: _buildAnimatedPage,
        );
      case SlideAnimation.rotation:
        return AnimatedPageView.rotation(
          controller: _pageController,
          itemCount: widget.project.images.length,
          onPageChanged: _handlePageChanged,
          itemBuilder: _buildAnimatedPage,
        );
      case SlideAnimation.slide:
        return AnimatedPageView.slide(
          controller: _pageController,
          itemCount: widget.project.images.length,
          onPageChanged: _handlePageChanged,
          itemBuilder: _buildAnimatedPage,
        );
      case SlideAnimation.cube:
        return AnimatedPageView.cube(
          controller: _pageController,
          itemCount: widget.project.images.length,
          onPageChanged: _handlePageChanged,
          itemBuilder: _buildAnimatedPage,
        );
      case SlideAnimation.flip:
        return AnimatedPageView.flip(
          controller: _pageController,
          itemCount: widget.project.images.length,
          onPageChanged: _handlePageChanged,
          itemBuilder: _buildAnimatedPage,
        );
      case SlideAnimation.stack:
        return AnimatedPageView.stack(
          controller: _pageController,
          itemCount: widget.project.images.length,
          onPageChanged: _handlePageChanged,
          itemBuilder: _buildAnimatedPage,
        );
    }
  }

  Widget _buildAnimatedPage(BuildContext context, int index) {
    return Hero(
      tag: widget.project.images[index].id,
      child: Image.file(
        File(widget.project.images[index].imagePath),
        fit: BoxFit.contain,
      ),
    );
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _changeAnimation(SlideAnimation animation) {
    setState(() {
      _currentAnimation = animation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        actions: [
          PopupMenuButton<SlideAnimation>(
            icon: const Icon(Icons.animation),
            onSelected: _changeAnimation,
            itemBuilder: (context) => SlideAnimation.values.map((animation) {
              return PopupMenuItem(
                value: animation,
                child: Text(animation.name.toUpperCase()),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildPageView(),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.project.images[_currentPage].title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Scenario ${_currentPage + 1} of ${widget.project.images.length}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Animation: ${_currentAnimation.name.toUpperCase()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}