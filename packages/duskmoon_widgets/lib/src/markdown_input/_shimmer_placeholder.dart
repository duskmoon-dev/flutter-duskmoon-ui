import 'package:flutter/material.dart';

/// A shimmer loading placeholder that mimics markdown content layout.
class ShimmerPlaceholder extends StatefulWidget {
  const ShimmerPlaceholder({super.key});

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = colorScheme.surfaceContainerLow;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading placeholder
                _bar(baseColor, width: 0.6, height: 20),
                const SizedBox(height: 16),
                // Paragraph lines
                _bar(baseColor, width: 1.0),
                const SizedBox(height: 6),
                _bar(baseColor, width: 0.95),
                const SizedBox(height: 6),
                _bar(baseColor, width: 0.8),
                const SizedBox(height: 16),
                // Another paragraph
                _bar(baseColor, width: 1.0),
                const SizedBox(height: 6),
                _bar(baseColor, width: 0.9),
                const SizedBox(height: 6),
                _bar(baseColor, width: 0.7),
                const SizedBox(height: 16),
                // Subheading
                _bar(baseColor, width: 0.4, height: 16),
                const SizedBox(height: 12),
                // List items
                _bar(baseColor, width: 0.85),
                const SizedBox(height: 6),
                _bar(baseColor, width: 0.75),
                const SizedBox(height: 6),
                _bar(baseColor, width: 0.8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bar(Color color, {double width = 1.0, double height = 12}) {
    return FractionallySizedBox(
      widthFactor: width,
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
