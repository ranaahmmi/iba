import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        SlideRightRoute(page: const LoginScreen()),
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BounceInDown(
          child: Image.asset(
            'assets/icons/ibd.png',
            height: 100,
          ),
        ),
      ),
    );
  }
}
