import 'package:unicheck_mobile/app/common/colors.dart';
import 'package:unicheck_mobile/utils/image_util.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatefulWidget {
  CustomButton({
    super.key,
    this.title = "",
    required this.onPressed,
    required this.background,
    this.isEnable = true,
    this.borderRadius = 10,
    this.fontSize = 16,
    this.width = 0,
    this.height = 60,
    this.gradient,
    this.borderColor,
    this.borderGradient,
    this.icon,
    this.titleColor,
    this.iconColor,
    this.widthBorder = 1,
    this.sizeIcon = 15,
    this.titleWidget,
    this.withShadow = false,
  });

  final String? title;
  final Function() onPressed;
  bool isEnable = true;
  Color background;
  double height = 0, width;
  double borderRadius = 0;
  double fontSize;
  LinearGradient? gradient;
  Color? borderColor;
  LinearGradient? borderGradient;
  String? icon;
  Color? titleColor;
  Color? iconColor;
  double widthBorder;
  double sizeIcon;
  Widget? titleWidget;
  bool withShadow;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.width == 0) {
      widget.width = 60;
    }

    bool isNeonStyle = widget.borderGradient != null;

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.icon != null
            ? ImageUtils.imageSvgAsset(
          height: widget.sizeIcon,
          width: widget.sizeIcon,
          name: widget.icon!,
          color: isNeonStyle ? Colors.white : widget.iconColor,
        )
            : const SizedBox(),
        widget.icon != null && widget.title != null
            ? const SizedBox(
          width: 11,
        )
            : const SizedBox(),
        widget.titleWidget ??
            Text(
              widget.title!,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500,
                color: isNeonStyle
                    ? Colors.white
                    : (widget.titleColor ?? AppColors.whiteColor),
              ),
            ),
      ],
    );

    if (isNeonStyle) {
      buttonContent = ShaderMask(
        shaderCallback: (bounds) => widget.borderGradient!.createShader(bounds),
        child: buttonContent,
      );
    }

    return GestureDetector(
      onTap: widget.isEnable ? widget.onPressed : null,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.8 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.withShadow && widget.borderGradient != null
                ? [
              BoxShadow(
                color: widget.borderGradient!.colors.first.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: -2,
              )
            ]
                : [],
            gradient: widget.borderGradient ?? widget.gradient,
            color: widget.gradient == null && widget.borderGradient == null
                ? widget.background
                : null,
            border: widget.borderColor != null && widget.borderGradient == null
                ? Border.all(
                color: widget.borderColor as Color,
                width: widget.widthBorder)
                : null,
          ),
          child: isNeonStyle
              ? Padding(
            padding: EdgeInsets.all(widget.widthBorder),
            child: Container(
              decoration: BoxDecoration(
                color: widget.background,
                borderRadius: BorderRadius.circular(
                    widget.borderRadius - widget.widthBorder),
              ),
              child: Center(child: buttonContent),
            ),
          )
              : Center(child: buttonContent),
        ),
      ),
    );
  }
}