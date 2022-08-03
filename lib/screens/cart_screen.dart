import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/data/network/api.dart';
import 'package:iba/data/riverpod/cart_item_notifier_provider.dart';
import 'package:iba/helper/app_buttons.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/helper/style.dart';
import 'package:iba/screens/custmors_screen.dart';
import 'package:iba/screens/home_screen.dart';
import 'package:iba/screens/item_categories_screen.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartstate = ref.watch(cartItemNotifierProvider);
    final user = User.fromJson(
      getJSONAsync('user'),
    );
    return SafeArea(
      child: LoadingOverlay(
        isLoading: cartstate.isloading,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: SizedBox(
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
                        right: 20,
                        child: const Center(
                                child: Text('Clear All',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)))
                            .onTap(() {
                          ref
                              .read(cartItemNotifierProvider.notifier)
                              .clearCart();
                        }),
                      ),
                    ],
                  ),
                )),
            body: cartstate.items.isEmpty
                ? cartEmpty(context, cartstate.items)
                : Column(
                    children: <Widget>[
                      'Order Detials'
                          .text
                          .bold
                          .color(AppColors.primaryColor)
                          .size(20)
                          .make(),
                      if (cartstate.custmor != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CartTileList(
                                    icon: Icons.person,
                                    title: cartstate.custmor?.csName ??
                                        'not given',
                                  ),
                                  10.heightBox,
                                  CartTileList(
                                    icon: Icons.location_on,
                                    title: cartstate.custmor?.address ??
                                        'not given',
                                  ),
                                ],
                              ),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.delete_outline,
                                  ),
                                  color: Colors.red,
                                  onPressed: () {
                                    ref
                                        .read(cartItemNotifierProvider.notifier)
                                        .removeCustomer();
                                  }),
                            ],
                          ),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.person_add),
                          color: AppColors.primaryColor,
                          iconSize: 26,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                                context,
                                SlideRightRoute(
                                    page: CustmorsScreen(
                                        isAddCart: true,
                                        placeID: user.branchId!)));
                          },
                        ).p(20),
                      10.heightBox,
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: cartstate.items.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return listItem(
                                index, context, ref, cartstate.items);
                          },
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 20, right: 20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Total Items',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              '${cartstate.items.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      AppCustomButton(
                          title: "Place Order",
                          height: 60,
                          isBoldtitle: true,
                          onpressed: () {
                            if (cartstate.custmor == null) {
                              showCustomDialogBottomAnimation(
                                context: context,
                                title: 'Please add customer',
                                onCancel: () {},
                                isShowCancleButton: false,
                                confirmButtonText: 'Cancel',
                                onConfirm: () => Navigator.pop(context),
                              );
                            } else {
                              showCustomDialogBottomAnimation(
                                context: context,
                                title: 'Are you sure you want to Place Order?',
                                onConfirm: () async {
                                  Navigator.pop(context);
                                  await ref
                                      .read(cartItemNotifierProvider.notifier)
                                      .orderPlace(user, context);

                                  ref
                                      .read(cartItemNotifierProvider.notifier)
                                      .clearCart();
                                },
                                onCancel: () => Navigator.pop(context),
                              );
                            }
                          }).p(20),
                    ],
                  )),
      ),
    );
  }

  cartEmpty(BuildContext context, List cartList) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            noCartImage(context),
            noCartText(context),
            noCartDec(context),
            shopNow(context)
          ]),
    );
  }

  Widget listItem(int index, BuildContext context, WidgetRef ref,
      List<ItemModel> cartList) {
    return Dismissible(
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          ref
              .read(cartItemNotifierProvider.notifier)
              .removerFromCart(cartList[index]);
        },
        key: Key(cartList[index].itemsPk!.toString()),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          alignment: AlignmentDirectional.centerEnd,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        child: CartItemlist(
          item: cartList[index],
          steppervalue: cartList[index].itemQuantity,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          onStepperChange: (value) {
            ref
                .read(cartItemNotifierProvider.notifier)
                .addQuantity(cartList[index], value);
          },
        ));
  }

  noCartImage(BuildContext context) {
    return Image.asset(
      'assets/images/empty_cart.png',
      height: MediaQuery.of(context).size.height * 0.2,
    );
  }

  noCartText(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Text("No Items Selected",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                color: AppColors.primaryColor, fontWeight: FontWeight.normal)));
  }

  noCartDec(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
      child: Text("Please select items for order",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.blueGrey,
                fontWeight: FontWeight.normal,
              )),
    );
  }

  shopNow(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 20, right: 20),
        child: AppCustomButton(
          title: 'Select Items',
          width: 250,
          height: 50,
          onpressed: () {
            Navigator.push(
                context, SlideRightRoute(page: const ItemCategoriesScreen()));
          },
        ));
  }
}

class CartTileList extends StatelessWidget {
  final String title;
  final IconData icon;
  const CartTileList({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primaryColor,
        ),
        8.widthBox,
        title.text.size(10).black.make(),
      ],
    ).pOnly(left: 20);
  }
}

class CartItemlist extends StatelessWidget {
  final ItemModel item;
  final Widget? buttonWidget;
  final Function(int)? onStepperChange;
  final int steppervalue;
  final EdgeInsetsGeometry? margin;

  const CartItemlist({
    Key? key,
    required this.item,
    this.buttonWidget,
    this.onStepperChange,
    this.steppervalue = 1,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 249, 252, 255),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 198, 216, 240).withOpacity(0.5),
              offset: const Offset(4, 10),
              blurRadius: 20,
            ),
          ]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: "$baseUrl/itemPic/${item.itemsPk}",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/noImageFound.png",
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
            ),
          ).wh(70, 70).px(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                '${item.itemName}'.text.bold.size(13).black.make(),
                8.heightBox,
                Align(
                  alignment: Alignment.centerRight,
                  child: VxStepper(
                    actionButtonColor: AppColors.primaryColor,
                    actionIconColor: Colors.white,
                    inputTextColor: AppColors.primaryColor,
                    onChange: onStepperChange,
                    defaultValue: steppervalue,
                  ).px(20),
                )
              ],
            ),
          ),
          if (buttonWidget != null) buttonWidget!
        ],
      ).pSymmetric(v: 5),
    );
  }
}
