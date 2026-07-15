import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Shimmer-like placeholder block.
///
/// Renders a rounded [AnimatedContainer] whose opacity oscillates between
/// two values to imitate the shimmer effect without depending on
/// `shimmer`/FFI. Drop-in replacement for any loading slot.
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.radius = DesignTokens.radiusSm,
    this.baseColor = const Color(0xFFEDE9E4),
    this.highlightColor = const Color(0xFFF7F4F0),
    this.duration = const Duration(milliseconds: 900),
  });

  final double? width;
  final double height;
  final double radius;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) {
        final t = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            color: Color.lerp(widget.baseColor, widget.highlightColor, t),
          ),
        );
      },
    );
  }
}

/// Convenience: a full-width text-line skeleton row.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.widthFactor = 1, this.height = 14});
  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor.clamp(0.1, 1.0),
        child: SkeletonLoader(height: height),
      ),
    );
  }
}
