import 'package:flutter/material.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/helper/app_buttons.dart';
import 'package:iba/helper/constants.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/helper/style.dart';
import 'package:iba/screens/custmors_screen.dart';
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
                  Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        DashboardCard(
                          title: 'Customers',
                          subTitle: 'view list of Customers',
                          iconColor: AppColors.primaryColor,
                          icon: Icons.person,
                          onTab: () {
                            Navigator.push(context,
                                SlideRightRoute(page: const CustmorsScreen()));
                          },
                        ),
                        DashboardCard(
                          title: 'Items',
                          subTitle: 'view list of Items',
                          iconColor: Colors.green,
                          icon: Icons.shopping_bag_outlined,
                          onTab: () {},
                        ),
                        DashboardCard(
                          title: 'Orders',
                          iconColor: Colors.orange,
                          subTitle: 'view list of Orders',
                          icon: Icons.shopping_cart_outlined,
                          onTab: () {},
                        ),
                        DashboardCard(
                          title: 'Target Reports',
                          iconColor: Colors.orange[900]!,
                          subTitle: 'view list of Reports',
                          icon: Icons.bar_chart_rounded,
                          onTab: () {},
                        ),
                        DashboardCard(
                          title: 'Daily Sales',
                          iconColor: Colors.green,
                          subTitle: 'view list of Reorts',
                          icon: Icons.receipt_outlined,
                          onTab: () {},
                        ),
                      ],
                    ),
                  ),
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
  final Function? onTab;
  final Color iconColor;
  const DashboardCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.iconColor,
    this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerButton(
      width: 160,
      height: 190,
      onTap: onTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 23,
            color: iconColor,
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
