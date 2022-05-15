import 'package:flutter/material.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/helper/constants.dart';
import 'package:iba/helper/style.dart';
import 'package:velocity_x/velocity_x.dart';

class SideDrawer extends StatelessWidget {
  final User user;

  const SideDrawer({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.8,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: AppColors.primaryColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(defaulProfilePicUrl),
                    radius: 35,
                  ),
                  10.widthBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      user.personName!.text.white.bold.size(12).make(),
                      3.heightBox,
                      user.branchName!.text.white.size(10).sm.make(),
                    ],
                  ).pOnly(top: 20),
                ],
              ).pOnly(top: 50, left: 20, right: 10),
            ),
            42.heightBox,
            DrawerTile(
              icon: Icons.person,
              text: 'My Profile',
              function: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final VoidCallback function;
  final String text;
  final IconData icon;
  const DrawerTile({
    Key? key,
    required this.function,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 30),
      onTap: function,
      leading: Icon(
        icon,
        color: Colors.black,
        size: 20,
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
      dense: true,
      style: ListTileStyle.list,
    ).h(43);
  }
}
