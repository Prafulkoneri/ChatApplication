import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PrimaryCTextFormField extends StatelessWidget {
  final String? titleHeader;
  final bool? readOnly;
  final double? height;
  final double? width;
  final int? maxLines;
  void Function(String)? onChanged;
  final LengthLimitingTextInputFormatter? lengthLimitingTextInputFormatter;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffix;
  final Color? color;
  final bool? enableBorder;
  final Color? borderColor;
  final void Function()? onTap;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextInputType? textInputType;

  PrimaryCTextFormField(
      {Key? key,
      this.onTap,
      this.textStyle,
      this.borderColor,
      this.maxLines,
      this.height,
      this.width,
      this.hintStyle,
      this.color,
      this.enableBorder,
      this.suffix,
      this.controller,
      this.titleHeader,
      this.readOnly,
      this.textInputType,
      this.onChanged,
      this.lengthLimitingTextInputFormatter,
      this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleHeader != null
            ? Row(
                children: [
                  Text(
                    titleHeader ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: const Color(0xff3A3A3A)),
                  ),
                ],
              )
            : Container(),
        titleHeader != null
            ? SizedBox(
                height: 10.w,
              )
            : Container(),
        SizedBox(
          height: height ?? 48.w,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            keyboardType: textInputType,
            style: textStyle,
            onTap: onTap,
            maxLines: maxLines ?? 1,
            readOnly: readOnly ?? false,
            onChanged: onChanged,
            inputFormatters: [
              lengthLimitingTextInputFormatter ??
                  LengthLimitingTextInputFormatter(1000),
            ],
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: suffix,
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              contentPadding: EdgeInsets.only(left: 10.w),
              hintStyle: hintStyle ??
                  TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffB7B7B7)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.w,
                  color: borderColor ?? const Color(0xffEFEFEF),
                ),
                borderRadius: BorderRadius.circular(5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? const Color(0xffE0E0E0),
                ),
                borderRadius: BorderRadius.circular(5.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class PrimarySTextFormField extends StatefulWidget {
  final String? titleHeader;
  final bool? readOnly;
  final double? height;
  final double? width;
  final int? maxLines;
  final void Function(String)? onChanged;
  final LengthLimitingTextInputFormatter? lengthLimitingTextInputFormatter;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffix;
  final Widget? preffix;
  final Color? color;
  final bool? enableBorder;
  final double? hintFontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final TextInputType? textInputType;
  final void Function()? onTap;
  final bool? obscureText; // Add obscureText property for password
  final bool? isPasswordField; // Add property to identify password field
  final double borderRadius; // New parameter for dynamic border radius

  const PrimarySTextFormField({
    Key? key,
    this.color,
    this.onTap,
    this.padding,
    this.height,
    this.width,
    this.hintFontSize,
    this.maxLines,
    this.enableBorder,
    this.suffix,
    this.preffix,
    this.controller,
    this.titleHeader,
    this.readOnly,
    this.onChanged,
    this.lengthLimitingTextInputFormatter,
    this.textInputType,
    this.fontWeight,
    this.hintText,
    this.obscureText,
        this.borderRadius = 5, // New parameter

    this.isPasswordField = false, // Default to false for non-password fields
  }) : super(key: key);

  @override
  _PrimarySTextFormFieldState createState() => _PrimarySTextFormFieldState();
}

class _PrimarySTextFormFieldState extends State<PrimarySTextFormField> {
  late bool _isPasswordHidden;

  @override
  void initState() {
    super.initState();
    _isPasswordHidden = widget.obscureText ?? false; // Initialize based on obscureText
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.titleHeader != null)
          Row(
            children: [
              Text(
                widget.titleHeader ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: const Color(0xff3A3A3A),
                ),
              ),
            ],
          ),
        if (widget.titleHeader != null)
          SizedBox(
            height: 10.w,
          ),
        SizedBox(
          height: widget.height ?? 48.w,
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            onTap: widget.onTap,
            maxLines: widget.maxLines ?? 1,
            keyboardType: widget.textInputType,
            readOnly: widget.readOnly ?? false,
            onChanged: widget.onChanged,
            obscureText: widget.isPasswordField! ? _isPasswordHidden : false, // Apply obscureText
            inputFormatters: [
              widget.lengthLimitingTextInputFormatter ??
                  LengthLimitingTextInputFormatter(1000),
            ],
            controller: widget.controller,
            decoration: InputDecoration(
              prefixIcon: widget.preffix,
              suffixIcon: widget.isPasswordField!
                  ? GestureDetector(
                      onTap: _togglePasswordVisibility,
                      child: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    )
                  : widget.suffix,
              fillColor: Colors.white,
              filled: true,
              hintText: widget.hintText,
              contentPadding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 15.0,
                  ),
              hintStyle: TextStyle(
                fontFamily: "Nunito Sans",
                fontSize: widget.hintFontSize ?? 14.sp,
                fontWeight: widget.fontWeight ?? FontWeight.normal,
                color: widget.color ?? const Color(0xff888888),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.4.w,
                  color: widget.enableBorder ?? false
                      ? const Color(0xff918F8F)
                      : const Color(0xff918F8F),
                ),
                borderRadius: BorderRadius.circular(5.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.4.w,
                  color: widget.enableBorder ?? false
                      ? const Color(0xff918F8F)
                      : const Color(0xff918F8F),
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius), // Apply dynamic border radius
              ),
            ),
          ),
        ),
      ],
    );
  }
}
