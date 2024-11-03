// lib/screens/image_slideshow_screen.dart
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
  stack,
  genie
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

class _ImageSlideshowScreenState extends State<ImageSlideshowScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late PageController _thumbnailController;
  late AnimationController _animationController;
  double _currentPage = 0;
  bool _isAnimating = false;
  SlideAnimation _currentAnimation = SlideAnimation.genie;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage.toInt());
    _thumbnailController = PageController(
      initialPage: _currentPage.toInt(),
      viewportFraction: 0.2,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pageController.addListener(_handlePageScroll);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageScroll);
    _pageController.dispose();
    _thumbnailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handlePageScroll() {
    setState(() {
      _currentPage = _pageController.page ?? 0;
    });
    // Sync thumbnail scroll
    _thumbnailController.animateTo(
      _pageController.offset / 5,
      duration: const Duration(milliseconds: 10),
      curve: Curves.linear,
    );
  }

  PageViewAnimation _getAnimation() {
    switch (_currentAnimation) {
      case SlideAnimation.fade:
        return PageViewAnimation.fade();
      case SlideAnimation.scale:
        return PageViewAnimation.scale();
      case SlideAnimation.rotation:
        return PageViewAnimation.rotation();
      case SlideAnimation.slide:
        return PageViewAnimation.slide();
      case SlideAnimation.cube:
        return PageViewAnimation.cube();
      case SlideAnimation.flip:
        return PageViewAnimation.flip();
      case SlideAnimation.stack:
        return PageViewAnimation.stack();
      case SlideAnimation.genie:
        return PageViewAnimation.genie();
    }
  }

  Widget _buildMainImageView() {
    return AnimatedPageView(
      controller: _pageController,
      itemCount: widget.project.images.length,
      onPageChanged: (index) {
        setState(() {
          _isAnimating = true;
        });
        _thumbnailController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ).then((_) {
          setState(() {
            _isAnimating = false;
          });
        });
      },
      itemBuilder: (context, index) => Image.file(
        File(widget.project.images[index].imagePath),
        fit: BoxFit.contain,
      ),
      animation: _getAnimation(),
    );
  }

  Widget _buildThumbnailStrip() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.black12,
      child: PageView.builder(
        controller: _thumbnailController,
        itemCount: widget.project.images.length,
        onPageChanged: (index) {
          if (!_isAnimating) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        itemBuilder: (context, index) {
          final bool isSelected = index == _currentPage.round();
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  File(widget.project.images[index].imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getAnimationName(SlideAnimation animation) {
    return animation.name.replaceFirst(
        animation.name[0],
        animation.name[0].toUpperCase()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        actions: [
          PopupMenuButton<SlideAnimation>(
            icon: const Icon(Icons.animation),
            tooltip: 'Change animation style',
            onSelected: (SlideAnimation animation) {
              setState(() {
                _currentAnimation = animation;
              });
            },
            itemBuilder: (context) => SlideAnimation.values.map((animation) {
              return PopupMenuItem(
                value: animation,
                child: Row(
                  children: [
                    Icon(
                      _currentAnimation == animation
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(_getAnimationName(animation)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMainImageView(),
          ),
          _buildThumbnailStrip(),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.project.images[_currentPage.round()].title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Scenario ${_currentPage.round() + 1} of ${widget.project.images.length}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Animation: ${_getAnimationName(_currentAnimation)}',
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