import 'package:flutter/material.dart';

class ButtonPlaceholder extends StatelessWidget {
  const ButtonPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        height: 100,
      ),
    );
  }
}