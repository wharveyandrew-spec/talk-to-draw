import 'dart:async';
import 'package:flutter/material.dart';

import 'DotLoadingIndicator.dart';
import 'home_screen.dart';


class MySplashPage extends StatefulWidget {
  const MySplashPage({super.key});

  @override
  State<MySplashPage> createState() => _SplashState();
}

class _SplashState extends State<MySplashPage> {
  @override
  void initState() {
    super.initState();
    initial();

  }

  void initial() async {
    startTimer();
  }



  void startTimer() {
    var duration = const Duration(seconds: 3);
    Timer(duration, route);
  }

  void route() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple.withOpacity(0.5),
        body: content(),
      );
  }

  Widget content() {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 200,
                child: Image.asset('assets/logos/logo.png'),
              ),
              const SizedBox(height: 50), // Space between logo and loader
              Center(
                child: DotLoadingIndicator(
                  dotColor: Colors.pink,
                  dotSize: 12,
                  totalDuration: Duration(milliseconds: 1600),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }



}
