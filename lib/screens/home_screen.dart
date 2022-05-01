import 'package:flutter/material.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/helper/app_buttons.dart';
import 'package:iba/helper/constants.dart';
import 'package:iba/helper/style.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: Icon(
                        Icons.list_sharp,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          'assets/icons/ibd.png',
                          height: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ).px(16),
              Container(
                height: 100,
                width: double.infinity,
                color: AppColors.primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                                  NetworkImage(defaulProfilePicUrl),
                              radius: 25,
                            ),
                            40.widthBox,
                            'Hello, Welcome back'
                                .text
                                .white
                                .size(10)
                                .sm
                                .make()
                                .py(10),
                          ],
                        ),
                        ('Mar 22, 2022').text.white.size(10).sm.make().py(10),
                      ],
                    ),
                    5.heightBox,
                    widget.user.personName!.text.white.bold.size(12).make(),
                    3.heightBox,
                    widget.user.branchName!.text.white.size(10).sm.make(),
                  ],
                ).pSymmetric(h: 25, v: 8),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  defaultpadding,
                  'Dashboard'.text.black.bold.size(20).make(),
                  defaultpadding,
                  const DashboardCard(
                    title: 'Customers',
                    subTitle: 'view list of Customers',
                    icon: Icons.person,
                  )
                ],
              ).px(25)
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title, subTitle;
  final IconData icon;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerButton(
      width: 146,
      height: 180,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 23,
            color: AppColors.primaryColor,
          ).p(10).box.roundedFull.color(AppColors.grey.withOpacity(0.2)).make(),
          defaultpadding,
          subTitle.text.color(AppColors.grey).size(10).make(),
          5.heightBox,
          title.text.black.bold.size(14).make(),
        ],
      ),
    );
  }
}
