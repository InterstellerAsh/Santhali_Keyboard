import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyPreview extends StatelessWidget {
  final String character;
  final Color backgroundColor;
  final Color textColor;
  final double keyWidth;
  final double keyHeight;

  const KeyPreview({
    super.key,
    required this.character,
    required this.backgroundColor,
    required this.textColor,
    required this.keyWidth,
    required this.keyHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: keyWidth * 1.5,
      height: keyHeight * 1.6,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Text(
          character,
          style: GoogleFonts.notoSansOlChiki(
            textStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
