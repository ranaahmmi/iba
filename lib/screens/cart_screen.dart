import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/data/riverpod/cart_item_notifier_provider.dart';
import 'package:iba/helper/app_buttons.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/helper/style.dart';
import 'package:iba/screens/custmors_screen.dart';
import 'package:iba/screens/item_categories_screen.dart';
import 'package:iba/screens/item_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartList = ref.watch(cartItemNotifierProvider);
    final custmor = ref.watch(cartCustomNotifierProvider);
    final user = User.fromJson(
      getJSONAsync('user'),
    );
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
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
                    const Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text('Cart',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
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
                        ref.read(cartItemNotifierProvider.notifier).clearCart();
                        ref.read(cartCustomNotifierProvider.notifier).state =
                            null;
                      }),
                    ),
                  ],
                ),
              ),
              preferredSize: const Size.fromHeight(80)),
          body: cartList.isEmpty
              ? cartEmpty(context, ref, cartList)
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: cartList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return listItem(index, context, ref, cartList);
                        },
                      ),
                    ),
                    custmor == null
                        ? AppCustomButton(
                            title: 'Add Customer',
                            isBoldtitle: true,
                            onpressed: () {
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                      page: CustmorsScreen(
                                          isAddCart: true,
                                          placeID: user.branchId!)));
                            },
                          ).p(20)
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 5),
                            child: Column(
                              children: [
                                CartTileList(
                                  title: 'Custmor:',
                                  subTitle: custmor.csName!,
                                ),
                                10.heightBox,
                                CartTileList(
                                  title: 'Adress:',
                                  subTitle: custmor.address!,
                                ),
                                10.heightBox,
                                Row(children: <Widget>[
                                  Text("remove custmor:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              fontWeight: FontWeight.w500)),
                                  const Spacer(),
                                  IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(cartCustomNotifierProvider
                                                .notifier)
                                            .state = null;
                                      }),
                                ]),
                              ],
                            ),
                          ),
                    const Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    10.heightBox,
                    CartTileList(
                      title: 'Agent:',
                      subTitle: user.personName!,
                    ).pSymmetric(h: 20, v: 5),
                    const Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5.0, left: 20, right: 20),
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
                            '${cartList.length}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    AppCustomButton(
                      title: "CHECKOUT",
                      height: 60,
                      isBoldtitle: true,
                      onpressed: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => GrobagCheckoutMobile()));
                      },
                    ).p(20),
                  ],
                )),
    );
  }

  cartEmpty(BuildContext context, WidgetRef ref, List cartList) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noCartImage(context),
          noCartText(context),
          noCartDec(context),
          shopNow(context)
        ]),
      ),
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
        child: ItemCards(
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
    return SvgPicture.network(
      'https://smartkit.wrteam.in/smartkit/grobag/emptycart.svg',
    );
  }

  noCartText(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Text("Your Cart Is Empty",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                color: AppColors.primaryColor, fontWeight: FontWeight.normal)));
  }

  noCartDec(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
      child: Text("Looking like you haven't added anything to your cart yet",
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
          title: 'Shop Now',
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
  final String title, subTitle;
  const CartTileList({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(title,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(subTitle)
      ],
    );
  }
}
