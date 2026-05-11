import 'package:flutter/material.dart';

/// Wraps a bid card with a smooth fade + slide-up entrance animation.
/// Because the [ListView.builder] assigns [ValueKey] on this wrapper,
/// Flutter reuses existing wrappers when the list polls for updates —
/// meaning only **new** bids animate in, and existing ones stay rock-solid.
class PostCardAnimatedWrapper extends StatefulWidget {
  final Widget child;
  final int index;

  const PostCardAnimatedWrapper({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  State<PostCardAnimatedWrapper> createState() => _PostCardAnimatedWrapperState();
}

class _PostCardAnimatedWrapperState extends State<PostCardAnimatedWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide =
        Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );

    // Stagger each card by 60ms so the list cascades in gracefully.
    final staggerDelay = Duration(milliseconds: widget.index * 60);
    Future.delayed(staggerDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
