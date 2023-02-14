import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

text({String? myText}) {
  return Text(
    myText!,
    style: GoogleFonts.getFont('Poppins',
        fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff094D57)),
  );
}
