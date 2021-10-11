import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String myPid = FirebaseAuth.instance.currentUser.uid.toString();

class TextWid extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final String family;
  final double lSpace;
  final int maxlines;
  final TextOverflow flow;
  final TextDecoration decoration;
  final TextAlign align;

  TextWid(
      {this.text,
      this.size,
      this.color,
      this.weight,
      this.family,
      this.maxlines,
      this.decoration,
      this.flow,
      this.align,
      this.lSpace});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: flow ?? TextOverflow.ellipsis,
        textAlign: align ?? TextAlign.start,
        maxLines: maxlines,
        style: GoogleFonts.josefinSans(
          decoration: decoration ?? TextDecoration.none,
          letterSpacing: lSpace ?? 0,
          fontSize: size ?? 14,
          color: color ?? Colors.black,
          fontWeight: weight ?? FontWeight.normal,
        ));
  }
}

// for text field stylish
fonts(size, bold, color) {
  return GoogleFonts.josefinSans(
    letterSpacing: 1,
    color: color,
    fontSize: size,
    fontWeight: bold,
  );
}
