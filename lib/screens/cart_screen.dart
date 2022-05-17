import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/riverpod/cart_item_notifier_provider.dart';
import 'package:iba/helper/style.dart';
import 'package:iba/screens/item_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartList = ref.watch(cartItemNotifierProvider);
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
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 5.0, left: 20, right: 20),
                      child: Row(
                        children: const <Widget>[
                          Text(
                            'Total Price',
                          ),
                          Spacer(),
                          Text("\$" "price")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      child: Row(
                        children: const <Widget>[
                          Text(
                            "Delivery Charge",
                          ),
                          Spacer(),
                          Text("\$" " delivery charge")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      child: Row(
                        children: const <Widget>[
                          Text(
                            "Discount",
                          ),
                          Spacer(),
                          Text('\$' " discount")
                        ],
                      ),
                    ),
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
                            'Grand Total',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            '\$' " total",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text("CHECKOUT",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ),
                      onPressed: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => GrobagCheckoutMobile()));
                      },
                    ),
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
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey,
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
          onStepperChange: (value) {
            ref
                .read(cartItemNotifierProvider.notifier)
                .addQuantity(cartList[index], value);
          },
        ));
  }

  noCartImage(BuildContext context) {
    return Image.network(
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
      padding: const EdgeInsets.only(top: 28.0),
      child: CupertinoButton(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 45,
            alignment: FractionalOffset.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text('Shop Now',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.normal))),
        onPressed: () {
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => GrobagHomeMobile()),
          //     ModalRoute.withName('/'));
        },
      ),
    );
  }
}
