import 'package:flutter/material.dart';

class DotLoadingIndicator extends StatefulWidget {
  final double dotSize;
  final Color dotColor;
  final Duration totalDuration;

  const DotLoadingIndicator({
    super.key,
    this.dotSize = 10.0,
    this.dotColor = Colors.white,
    this.totalDuration = const Duration(milliseconds: 1600),
  });

  @override
  State<DotLoadingIndicator> createState() => _DotLoadingIndicatorState();
}

class _DotLoadingIndicatorState extends State<DotLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getScale(double progress, double start, double end) {
    if (progress < start || progress > end) return 0.5;

    final localProgress = (progress - start) / (end - start);
    if (localProgress <= 0.5) {
      // Grow from 0.5 to 1.0
      return 0.5 + (localProgress * 1.0);
    } else {
      // Shrink from 1.0 to 0.5
      return 1.5 - (localProgress * 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final progress = _controller.value;

        final scale1 = _getScale(progress, 0.0, 0.3);
        final scale2 = _getScale(progress, 0.2, 0.5);
        final scale3 = _getScale(progress, 0.4, 0.7);
        final scale4 = _getScale(progress, 0.6, 0.9);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(scale1),
            const SizedBox(width: 8),
            _buildDot(scale2),
            const SizedBox(width: 8),
            _buildDot(scale3),
            const SizedBox(width: 8),
            _buildDot(scale4),
          ],
        );
      },
    );
  }

  Widget _buildDot(double scale) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: widget.dotSize,
        height: widget.dotSize,
        decoration: BoxDecoration(
          color: widget.dotColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
