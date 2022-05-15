import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/screens/home_screen.dart';
import 'package:iba/screens/login_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initfunction();
    super.initState();
  }

  initfunction() async {
    Future.delayed(const Duration(seconds: 2), () {
      print(getBoolAsync('islogin'));
      print(getJSONAsync('user'));
      if (getBoolAsync('islogin')) {
        Navigator.pushReplacement(
          context,
          SlideRightRoute(
            page: HomeScreen(
              user: User.fromJson(
                getJSONAsync('user'),
              ),
            ),
          ),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          SlideRightRoute(page: const LoginScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Image.asset(
            'assets/icons/ibd.png',
            height: 100,
          ),
        ),
      ),
    );
  }
}
