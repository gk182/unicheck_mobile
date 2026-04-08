import 'package:flutter/material.dart';

class FaceScannerAnimation extends StatefulWidget {
  const FaceScannerAnimation({Key? key}) : super(key: key);

  @override
  State<FaceScannerAnimation> createState() => _FaceScannerAnimationState();
}

class _FaceScannerAnimationState extends State<FaceScannerAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 280,
          height: 380,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.elliptical(280, 380)),
            border: Border.all(
              color: const Color(0xFF1C51E6).withOpacity(_animation.value),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1C51E6).withOpacity(_animation.value * 0.5),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
        );
      },
    );
  }
}