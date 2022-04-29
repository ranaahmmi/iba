import 'package:flutter/material.dart';
import 'package:iba/helper/style.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 172,
            color: AppColors.primaryColor,
            child: Center(child: Image.asset('assets/icons/ibdw.png')),
          ),
          40.heightBox,
          AppButton(
            text: "Sign In",
            height: 55,
            color: AppColors.primaryColor,
            onTap: () {},
          ),
          30.heightBox,
        ],
      ),
    );
  }
}
