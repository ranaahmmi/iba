import 'package:awesome_dialog/awesome_dialog.dart' as awesome;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/models/order_place_model.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/data/network/api.dart';
import 'package:iba/data/riverpod/cart_item_notifier_provider.dart';
import 'package:iba/helper/app_buttons.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/helper/style.dart';
import 'package:iba/screens/custmors_screen.dart';
import 'package:iba/data/models/invoice_model.dart';
import 'package:iba/screens/item_categories_screen.dart';
import 'package:iba/screens/pdf_invoice.dart';
import 'package:iba/screens/pdf_view.dart';
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
                      const Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text('Take Order',
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
                      cartstate.custmor == null
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
                                    subTitle: cartstate.custmor?.csName ??
                                        'not given',
                                  ),
                                  10.heightBox,
                                  CartTileList(
                                    title: 'Adress:',
                                    subTitle: cartstate.custmor?.address ??
                                        'not given',
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
                                              .read(cartItemNotifierProvider
                                                  .notifier)
                                              .removeCustomer();
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
                              awesome.AwesomeDialog(
                                context: context,
                                animType: awesome.AnimType.SCALE,
                                dialogType: awesome.DialogType.ERROR,
                                desc: 'Please add customer',
                                btnCancelOnPress: () {},
                                title: 'Error',
                              ).show();
                            } else {
                              awesome.AwesomeDialog(
                                context: context,
                                animType: awesome.AnimType.SCALE,
                                dialogType: awesome.DialogType.QUESTION,
                                body: const Center(
                                  child: Text(
                                    'Are you sure you want to Place Order?',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                title: 'Confirmation',
                                desc: 'Are you sure you want to Place Order?',
                                btnOkColor: AppColors.primaryColor,
                                btnOkOnPress: () async {
                                  final OrderPlaceModel orderData = await ref
                                      .read(cartItemNotifierProvider.notifier)
                                      .orderPlace(user);
                                  // print(
                                  //     "branchId: ${orderData.agent.branchId}");
                                  // print(
                                  //     'Custmor: ${orderData.custmor.cusSupPk}');
                                  // print('Remarks: ${orderData.items.length}');
                                  // for (var item in orderData.items) {
                                  //   print('Item ID: ${item.itemsPk}');
                                  //   print('Item name: ${item.itemName}');
                                  //   print('Quantity: ${item.itemQuantity}');
                                  // }
                                  ref
                                      .read(cartItemNotifierProvider.notifier)
                                      .clearCart();
                                  final date = DateTime.now();
                                  final dueDate =
                                      date.add(const Duration(days: 7));
                                  final invoice = Invoice(
                                    supplier: Supplier(
                                      name: orderData.agent.personName ??
                                          'not given',
                                      address: orderData.agent.branchName ??
                                          'not given',
                                      paymentInfo:
                                          'PAY TO ${orderData.agent.personName}',
                                    ),
                                    customer: Customer(
                                      name: orderData.custmor.csName ??
                                          'not given',
                                      address: orderData.custmor.address ??
                                          'not given',
                                    ),
                                    info: InvoiceInfo(
                                      date: DateTime.now(),
                                      dueDate: dueDate,
                                      description: 'My description...',
                                      number: "INV-${orderData.orderHeadPk}",
                                    ),
                                    items: orderData.items.map((element) {
                                      return InvoiceItem(
                                        description:
                                            element.itemName ?? 'not given',
                                        date: DateTime.now(),
                                        quantity: element.itemQuantity,
                                        vat: 0.00,
                                        unitPrice: 0.00,
                                      );
                                    }).toList(),
                                  );

                                  final pdfFile =
                                      await PdfInvoiceApi.generate(invoice);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      SlideRightRoute(
                                          page: PDFScreen(
                                        path: pdfFile.path,
                                      )),
                                      (Route<dynamic> route) => route.isFirst);
                                },
                                btnCancelOnPress: () {},
                              ).show();
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
    return SvgPicture.network(
      'https://smartkit.wrteam.in/smartkit/grobag/emptycart.svg',
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
        10.widthBox,
        Expanded(child: subTitle.text.overflow(TextOverflow.ellipsis).make())
      ],
    );
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
