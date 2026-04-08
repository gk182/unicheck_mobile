import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' as ui;

class ImageUtils {
  static imageSvgAsset(
      {String name = "ic_group",
      double height = 24,
      double width = 24,
      Color? color}) {
    return SvgPicture.asset(
      "assets/svgs/$name.svg",
      height: height,
      width: width,
      // ignore: deprecated_member_use
      color: color,
    );
  }

  static Widget imageAssetApp(
      {String name = "ic_add",
      String extension = "png",
      double? height,
      double? width,
      BoxFit? boxFit,
      Color? color,
      BoxBorder? border,
      BorderRadius? borderRadius,
      bool isCircle = false,}
    ) 
      {
      Widget image = Image.asset(
        "assets/images/$name.$extension",
        height: height,
        width: width,
        fit: boxFit,
        color: color,
      );

    if (isCircle) {
    return ClipOval(
      child: SizedBox(
        height: height,
        width: width,
        child: image,
      ),
    );
  }

    if (border != null || borderRadius != null) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
        ),
        child: borderRadius != null
            ? ClipRRect(borderRadius: borderRadius, child: image)
            : image,
      );
    }
    return image;
  }

  static Future<ui.Image> loadUiImage(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}
