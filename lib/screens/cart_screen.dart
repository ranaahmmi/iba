import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iba/helper/style.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double disPrice = 10, oriPrice = 1000, delCharge = 100, totalPrice = 890;
  List cartList = [
    {
      'img': "https://smartkit.wrteam.in/smartkit/grobag/cart-image-a.png",
      'name': "Jasmine Rice Unmilled",
      'descprice': "45",
      'price': "50f",
      'qty': '250 gm',
      'cartCount': 1
    },
    {
      'img': "https://smartkit.wrteam.in/smartkit/grobag/cart-image-b.png",
      'name': "Garden Freshly Roasted Salted Cashew Nuts",
      'descprice': "250",
      'price': "500",
      'qty': '250 gm',
      'cartCount': 1
    },
    {
      'img': "https://smartkit.wrteam.in/smartkit/grobag/cart-image-c.png",
      'name': "Good Fermented and Sun Dried Cocoa Beans",
      'descprice': "25",
      'price': "50",
      'qty': "1 kg",
      'cartCount': 1
    },
    {
      'img': "https://smartkit.wrteam.in/smartkit/grobag/cart-image-d.png",
      'name': "American Sweet Corn Unpeeled",
      'descprice': "1000",
      'price': "1200",
      'qty': '500 gm',
      'cartCount': 1
    },
    {
      'img': "https://smartkit.wrteam.in/smartkit/grobag/cart-image-e.png",
      'name': "Sprouting Seeds Mung Beans",
      'descprice': "1300",
      'price': "1400",
      'qty': '2 kg',
      'cartCount': 1
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const GrobagAppbar(title: 'Cart'),
        body: cartList.isEmpty
            ? cartEmpty()
            : Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: cartList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return listItem(index);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 5.0, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        const Text(
                          'Total Price',
                        ),
                        const Spacer(),
                        Text("\$" "$oriPrice")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Row(
                      children: <Widget>[
                        const Text(
                          "Delivery Charge",
                        ),
                        const Spacer(),
                        Text("\$" " $delCharge")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Row(
                      children: <Widget>[
                        const Text(
                          "Discount",
                        ),
                        const Spacer(),
                        Text('\$' " $disPrice")
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
                          '\$' " $totalPrice",
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
              ));
  }

  cartEmpty() {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noCartImage(context),
          noCartText(context),
          noCartDec(context),
          shopNow()
        ]),
      ),
    );
  }

  Widget listItem(int index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      
      onDismissed: (direction) {
        setState(() {
          cartList.removeAt(index);
        });
      },
      key: Key(cartList[index]["name"]),
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
      child: Card(
        elevation: 0.1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: cartList[index]["img"],
                height: 80,
                width: 80,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        cartList[index]["qty"],
                        // style: TextStyle(color: secondary),
                      ),
                      Text(
                        cartList[index]["name"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsetsDirectional.only(
                                      end: 8, top: 8, bottom: 8),
                                  child: Icon(
                                    Icons.remove,
                                    size: 14,
                                    color: AppColors.primaryColor,
                                  ),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                ),
                                onTap: () {
                                  if (cartList[index]["cartCount"] != 1) {
                                    setState(() {
                                      cartList[index]["cartCount"] =
                                          cartList[index]["cartCount"] - 1;
                                    });
                                  }
                                },
                              ),
                              Text("${cartList[index]["cartCount"]}"),
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.add,
                                    size: 14,
                                    color: AppColors.primaryColor,
                                  ),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                ),
                                onTap: () {
                                  setState(() {
                                    cartList[index]["cartCount"] =
                                        cartList[index]["cartCount"] + 1;
                                  });
                                },
                              )
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "\$" + cartList[index]["descprice"] + "  ",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: AppColors.primaryColor),
                              ),
                              Text(
                                "\$" + cartList[index]["price"],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  shopNow() {
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

class GrobagAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String? title;

  const GrobagAppbar({Key? key, this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Builder(builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        );
      }),
      title: Text(
        title!,
        style: TextStyle(
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
