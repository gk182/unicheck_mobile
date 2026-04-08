import 'package:flutter/material.dart';
import 'package:unicheck_mobile/utils/image_util.dart';
Widget textWithRightSvg({
  required List<String> texts,
  required String svgName,
  double svgSize = 16,
  TextStyle? textStyle,
  Color? svgColor,
  double spacing = 6,
  int? maxLines,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: crossAxisAlignment,
    children: [
      ImageUtils.imageSvgAsset(
        name: svgName,
        width: svgSize,
        height: svgSize,
        color: svgColor,
      ),
      SizedBox(width: spacing),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: texts
              .map(
                (text) => Text(
                  text,
                  style: textStyle ?? const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines,
                ),
              )
              .toList(),
        ),
      ),
    ],
  );
}
