import 'package:flutter/material.dart';

class GardenifiLogo extends StatelessWidget {
  const GardenifiLogo({
    super.key,
    required this.height,
    required this.divider,
  });

  final double height;
  final double divider;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.fill,
      height: height / divider,
      // width: radious,
    );
  }
}
