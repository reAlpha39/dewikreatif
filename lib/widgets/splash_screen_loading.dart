import 'package:flutter/material.dart';

class SplashScreenLoading extends StatelessWidget {
  const SplashScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1BCD7C),
                Color(0xFF005B7A),
              ],
            ),
          ),
          //color: const Color(0xFF34495E),
          child: Center(
            child: Image.asset('assets/rejo.png'),
          ),
        ),
      ),
    );
  }
}
