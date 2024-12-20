import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final Color? color;
  final String? text;
  final Color? textColor;
  final VoidCallback? onTap;
  final Widget? leading;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final Color? borderColor;
  final Widget? child;

  const PrimaryButton(
      {Key? key,
      this.leading,
      this.child,
      this.borderColor,
      this.width,
      this.height,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      this.text,
      this.borderRadius,
      required this.color,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? 45.w,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(borderRadius ?? 8.w),
              border: Border.all(color: borderColor ?? Colors.transparent)),
          child: leading ?? Center(
                  child: child ??
                      Text(
                        "$text",
                        style: TextStyle(
                            color: textColor ?? Colors.white,
                            fontWeight: fontWeight ?? FontWeight.w700,
                            fontSize: fontSize ?? 25.sp),
                      ))),
    );
  }
}
