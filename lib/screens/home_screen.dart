import 'package:flutter/material.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/helper/app_buttons.dart';
import 'package:iba/helper/constants.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/helper/style.dart';
import 'package:iba/screens/cart_screen.dart';
import 'package:iba/screens/custmors_screen.dart';
import 'package:iba/screens/item_categories_screen.dart';
import 'package:iba/screens/side_drawer.dart';
import 'package:iba/screens/target_report_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SideDrawer(
          user: widget.user,
        ),
        body: WillPopScope(
          onWillPop: () {
            return _onBackPressed(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.sort,
                          size: 34,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
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
                        const Clock().pOnly(top: 10),
                      ],
                    ),
                    5.heightBox,
                    widget.user.personName!.text.white.bold.size(12).make(),
                    3.heightBox,
                    widget.user.branchName!.text.white.size(10).sm.make(),
                  ],
                ).pSymmetric(h: 25, v: 8),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                            DashboardAnimationButton(
                              title: 'Customers',
                              subTitle: 'view list of Customers',
                              iconColor: AppColors.primaryColor,
                              icon: Icons.person,
                              onTab: () {
                                Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: CustmorsScreen(
                                      placeID: widget.user.branchId!,
                                    )));
                              },
                            ),
                            DashboardAnimationButton(
                              title: 'Items',
                              subTitle: 'view list of Items',
                              iconColor: Colors.green,
                              icon: Icons.shopping_bag_outlined,
                              onTab: () {
                                Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const ItemCategoriesScreen()));
                              },
                            ),
                            DashboardAnimationButton(
                              title: 'Orders',
                              iconColor: Colors.orange,
                              subTitle: 'view list of Orders',
                              icon: Icons.shopping_cart_outlined,
                              onTab: () {
                                Navigator.push(context,
                                    SlideRightRoute(page: const CartScreen()));
                              },
                            ),
                            DashboardAnimationButton(
                              title: 'Target Reports',
                              iconColor: Colors.orange[900]!,
                              subTitle: 'view list of Reports',
                              icon: Icons.bar_chart_rounded,
                              onTab: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SaleTargetChart()),
                                );
                              },
                            ),
                            // DashboardAnimationButton(
                            //   title: 'Daily Sales',
                            //   iconColor: Colors.green,
                            //   subTitle: 'view list of Reorts',
                            //   icon: Icons.receipt_outlined,
                            //   onTab: () {},
                            // ),
                          ],
                        ),
                      ),
                      defaultpadding,
                    ],
                  ).px(20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return await showCustomDialogBottomAnimation(
        context: context,
        title: 'Do you really want to exit',
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false));
  }
}

class Clock extends StatelessWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(minutes: 1)),
      builder: (context, snapshot) {
        return Column(
          children: [
            DateFormat('dd-MM-yyyy')
                .format(DateTime.now())
                .text
                .wide
                .white
                .make(),
            DateFormat.jm().format(DateTime.now()).text.wide.white.make(),
          ],
        );
      },
    );
  }
}

showCustomDialogBottomAnimation(
    {required BuildContext context,
    required String title,
    bool isShowCancleButton = true,
    double height = 150,
    String confirmButtonText = 'Yes',
    String cancelButtonText = 'No',
    required VoidCallback onCancel,
    required VoidCallback onConfirm}) {
  return showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (BuildContext context, __, ___) {
      return Material(
        color: Colors.transparent,
        child: Align(
            alignment: Alignment.center,
            child: Center(
              child: Container(
                height: height,
                width: context.screenWidth * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    10.heightBox,
                    const Spacer(),
                    title.text
                        .fontWeight(FontWeight.w500)
                        .size(18)
                        .black
                        .make(),
                    const Spacer(
                      flex: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppCustomButton(
                            width: 100,
                            height: 40,
                            shadowColor: AppColors.primaryColor,
                            elevation: 4,
                            title: confirmButtonText,
                            onpressed: onConfirm),
                        if (isShowCancleButton)
                          Row(
                            children: [
                              20.widthBox,
                              AppCustomButton(
                                  width: 100,
                                  height: 40,
                                  shadowColor: AppColors.primaryColor,
                                  elevation: 4,
                                  title: cancelButtonText,
                                  onpressed: onCancel),
                            ],
                          ),
                      ],
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                  ],
                ).p(10),
              ),
            )),
      );
    },
    transitionBuilder: (context, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(CurvedAnimation(
          parent: anim,
          curve: Curves.easeInOutCirc,
        )),
        child: child,
      );
    },
  );
}
