import 'package:flutter/material.dart';

class BowlClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = 40.0;
    path.moveTo(0, 0);

    path.quadraticBezierTo(size.width / 2, curveHeight, size.width, 0);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
