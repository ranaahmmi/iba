import 'package:flutter/material.dart';
import 'package:iba/helper/style.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
          AppTextField(
            controller: _emailController, // Optional
            textFieldType: TextFieldType.EMAIL,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          20.heightBox,
          AppTextField(
            controller: _passwordController, // Optional
            textFieldType: TextFieldType.PASSWORD,
            decoration: const InputDecoration(
                labelText: 'Password', border: OutlineInputBorder()),
          ),
          30.heightBox,
          AppButton(
            text: "Sign In",
            height: 55,
            color: AppColors.primaryColor,
            onTap: () {},
          ),
          30.heightBox,
          CheckboxListTile(
            title: "Remember me".text.color(AppColors.primaryColor).make(),
            value: true,
            onChanged: (bool? value) {},
          ),
        ],
      ),
    );
  }
}
