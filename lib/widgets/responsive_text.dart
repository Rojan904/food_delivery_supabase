import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/core/size_config.dart';

class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.textColor,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.fontFamily,
    this.fontStyle,
    this.textOverflow,
    this.maxLines,
    this.decoration,
    this.height,
    this.overflow,
    this.letterSpacing,
  });

  final double fontSize;
  final String text;
  final Color? textColor;
  final TextAlign textAlign;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final int? maxLines;
  final double? height;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      textScaler: const TextScaler.linear(1),
      overflow: overflow,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        decoration: decoration,
        color: textColor,
        height: height,
        fontFamily: 'Poppins',
        fontSize: getResponsiveFont(fontSize),
        fontWeight: fontWeight,
        overflow: textOverflow,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      ),
      maxLines: maxLines,
    );
  }
}
