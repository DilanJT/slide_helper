import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:slide_helper/widgets/animations/page_view_animation.dart';

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

    // Screen dimensions for relative calculations
    final Size screenSize = MediaQuery.of(context).size;
    final double thumbnailHeight = 100.0;

    // Animation progress with custom easing
    final double progress = _smoothStepProgress(1.0 - distance.clamp(0.0, 1.0));

    // Calculate transformations
    final double scaleX = _lerpDouble(0.2, 1.0, progress); // 0.2 is viewportFraction
    final double scaleY = _lerpDouble(thumbnailHeight / screenSize.height, 1.0, progress);
    final double opacity = _lerpDouble(0.6, 1.0, progress);

    // Calculate wave parameters
    final double waveProgress = isLeaving ? distance : (1.0 - distance);
    final double waveIntensity = (1.0 - progress) * 0.3;

    return Stack(
      children: [
        Transform(
          alignment: isLeaving ? Alignment.bottomRight : Alignment.bottomLeft,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Add perspective
            ..scale(scaleX, scaleY)
            ..translate(
              0.0,
              _bezierY(progress, screenSize.height * 0.4, 0.0) * (isLeaving ? 1 : -1),
              0.0,
            )
            ..rotateZ(_lerpDouble(
              isLeaving ? math.pi / 16 : -math.pi / 16,
              0.0,
              progress,
            )),
          child: ClipPath(
            clipper: GenieWaveClipper(
              progress: waveProgress,
              intensity: waveIntensity,
              isLeaving: isLeaving,
            ),
            child: Opacity(
              opacity: opacity,
              child: builder(),
            ),
          ),
        ),
      ],
    );
  }

  // Custom easing function for smoother animation
  double _smoothStepProgress(double t) {
    final double t2 = t * t;
    final double t3 = t2 * t;
    return -2 * t3 + 3 * t2;
  }

  // Cubic bezier for vertical movement
  double _bezierY(double t, double start, double end) {
    final double oneMinusT = 1.0 - t;
    final double t2 = t * t;
    final double oneMinusT2 = oneMinusT * oneMinusT;

    return oneMinusT2 * start + 2 * oneMinusT * t * (start * 0.5) + t2 * end;
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

class GenieWaveClipper extends CustomClipper<Path> {
  final double progress;
  final double intensity;
  final bool isLeaving;

  GenieWaveClipper({
    required this.progress,
    required this.intensity,
    required this.isLeaving,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    if (progress == 0.0) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    }

    final int segments = 20;
    final double segmentWidth = size.width / segments;
    final double maxWaveHeight = size.height * intensity;

    path.moveTo(0, 0);

    // Top edge with wave effect
    for (int i = 0; i <= segments; i++) {
      final double x = i * segmentWidth;
      final double normalizedX = x / size.width;
      final double wavePhase = isLeaving ? normalizedX : (1 - normalizedX);

      // Combine multiple sine waves for more organic movement
      final double wave1 = math.sin(wavePhase * math.pi * 2) * maxWaveHeight;
      final double wave2 = math.sin(wavePhase * math.pi * 4) * maxWaveHeight * 0.5;

      // Apply gaussian envelope for smooth falloff at edges
      final double envelope = _gaussianPulse(normalizedX);
      final double waveHeight = (wave1 + wave2) * envelope * progress;

      path.lineTo(x, waveHeight);
    }

    // Complete the path
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  double _gaussianPulse(double x) {
    final double mean = isLeaving ? 0.3 : 0.7;
    final double sigma = 0.3;
    final double exponent = -math.pow(x - mean, 2) / (2 * sigma * sigma);
    return math.exp(exponent);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}