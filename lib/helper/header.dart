import 'package:flutter/material.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/screens/cart_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.title,
    this.isShowCart = true,
  }) : super(key: key);
  final String title;
  final bool isShowCart;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: title.text.bold.size(14).black.makeCentered(),
          ),
          if (isShowCart)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.push(
                    context, SlideRightRoute(page: const CartScreen())),
              ),
            ),
        ],
      ),
    ).px(16);
  }
}
