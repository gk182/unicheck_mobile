import 'package:flutter/material.dart';

class QrAnimatedLine extends StatefulWidget {
  const QrAnimatedLine({Key? key}) : super(key: key);

  @override
  State<QrAnimatedLine> createState() => _QrAnimatedLineState();
}

class _QrAnimatedLineState extends State<QrAnimatedLine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 240).animate(_controller);
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
        return Positioned(
          top: _animation.value,
          child: Container(
            width: 250,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF1C51E6),
              boxShadow: [
                BoxShadow(color: const Color(0xFF1C51E6).withOpacity(0.5), blurRadius: 10, spreadRadius: 2)
              ],
            ),
          ),
        );
      },
    );
  }
}