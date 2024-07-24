import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// The `Loader` class is a  widget that displays a loading animation with a blue color filter
/// applied to it.
class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.blue[300]!,
          BlendMode.modulate,
        ),
        child: Lottie.asset(
          'assets/loader.json',
          repeat: true,
          reverse: true,
          animate: true,
        ),
      ),
    );
  }
}
