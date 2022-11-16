import 'package:flutter/material.dart';

class SplashScreenLoading extends StatelessWidget {
  const SplashScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF34495E),
        child: Center(
          child: Image.asset('assets/maskot.png'),
        ),
      ),
    );
  }
}
