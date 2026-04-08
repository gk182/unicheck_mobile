import 'package:flutter/material.dart';

class FaceOverlay extends StatelessWidget {
  const FaceOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.7),
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 280,
                height: 380,
                decoration: const BoxDecoration(
                  color: Colors.black, 
                  borderRadius: BorderRadius.all(Radius.elliptical(280, 380)), 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}