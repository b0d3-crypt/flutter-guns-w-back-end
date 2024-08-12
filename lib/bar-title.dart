import 'package:flutter/material.dart';

class BarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/image/magnum_python.png',
          scale: 8,
        ),
        const SizedBox(
          width: 5,
        ),
        const Text(
          ' GUNS',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
      ],
    );
  }
}
