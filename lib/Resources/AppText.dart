import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String fontFamily;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final Color textDecorationColor;
  final double maxLines;

  const AppText({
    super.key,
    required this.text,
    this.fontSize = 12,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black, this.fontFamily = 'Roboto', this.textAlign = TextAlign.center,
    this.textDecoration = TextDecoration.none, this.textDecorationColor = Colors.white,  this.maxLines = 1
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
        decoration: textDecoration,
          decorationColor: textDecorationColor
      ),
    );
  }
}