import 'package:flutter/material.dart';
import 'package:iba/data/models/custmor_model.dart';
import 'package:iba/helper/app_buttons.dart';
import 'package:iba/helper/constants.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/helper/style.dart';
import 'package:iba/screens/map.dart';
import 'package:velocity_x/velocity_x.dart';

class CustmorsProfile extends StatelessWidget {
  final CustmorModel custmor;
  const CustmorsProfile({Key? key, required this.custmor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 290,
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      color: AppColors.primaryColor,
                    ),
                    Positioned(
                        top: 30,
                        left: 26,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: AppColors.primaryColor,
                        )
                            .p(15)
                            .box
                            .color(Colors.white)
                            .roundedFull
                            .make()
                            .onTap(() {
                          context.pop();
                        })),
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Column(
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                                  NetworkImage(defaulProfilePicUrl),
                              radius: 60,
                            ),
                            20.heightBox,
                            custmor.csName!.text
                                .color(AppColors.primaryColor)
                                .bold
                                .size(16)
                                .make(),
                            3.heightBox,
                            custmor.address!.text
                                .color(AppColors.primaryColor)
                                .size(10)
                                .sm
                                .make(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              defaultpadding,
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    DashboardAnimationButton(
                      title: 'Orders',
                      iconColor: Colors.blue,
                      subTitle: 'place order for this custmor',
                      icon: Icons.shopping_cart_outlined,
                      onTab: () {},
                    ),
                    DashboardAnimationButton(
                      title: 'Update Location',
                      iconColor: Colors.green,
                      subTitle: 'update lat-long',
                      icon: Icons.location_on_outlined,
                      onTab: () {
                        Navigator.push(
                            context,
                            SlideRightRoute(
                                page: MapPicker(
                              lat: custmor.latitude ?? 31.5204,
                              lng: custmor.longitude ?? 74.3587,
                            )));
                      },
                    ),
                    DashboardAnimationButton(
                      title: 'Invoice History',
                      subTitle: 'view history',
                      iconColor: Colors.orange,
                      icon: Icons.timer_sharp,
                      onTab: () {},
                    ),
                    DashboardAnimationButton(
                      title: 'Target Reports',
                      iconColor: Colors.orange[900]!,
                      subTitle: 'view list of Reports',
                      icon: Icons.bar_chart_rounded,
                      onTab: () {},
                    ),
                  ],
                ),
              ).px(25)
            ],
          ),
        ),
      ),
    );
  }
}
