import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/network/api.dart';
import 'package:iba/data/riverpod/cart_item_notifier_provider.dart';
import 'package:iba/data/riverpod/item/item_notifier_provider.dart';
import 'package:iba/helper/constants.dart';
import 'package:iba/helper/header.dart';
import 'package:iba/helper/style.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  final int categoryID;
  const ItemsScreen({Key? key, required this.categoryID}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref
          .read(itemNotifierProvider.notifier)
          .getItem(widget.categoryID, _searchController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemState = ref.watch(itemNotifierProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderWidget(
              title: 'Item',
            ),
            AppTextField(
              controller: _searchController,
              textFieldType: TextFieldType.NAME,
              onFieldSubmitted: (value) {
                ref
                    .read(itemNotifierProvider.notifier)
                    .getItem(widget.categoryID, _searchController.text);
              },
              decoration: Constatnts().appInputDucoration(
                  'Search Items', AppColors.primaryColor,
                  icon: Icons.search),
            ).px(10),
            10.heightBox,
            itemState is ItemLoadedState
                ? Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      onRefresh: () async {
                        await ref
                            .read(itemNotifierProvider.notifier)
                            .getItem(widget.categoryID, _searchController.text);
                        _refreshController.loadComplete();
                      },
                      onLoading: () async {
                        final bool result = await ref
                            .read(itemNotifierProvider.notifier)
                            .getItemLoadMore(
                                widget.categoryID, _searchController.text);

                        if (result) {
                          _refreshController.loadComplete();
                          _refreshController.refreshCompleted();
                          setState(() {});
                        } else {
                          _refreshController.loadNoData();
                          setState(() {});
                        }
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemState.itemList!.length,
                          itemBuilder: (context, index) {
                            return ItemCards(
                              item: itemState.itemList![index],
                              buttonWidget: ref
                                      .watch(cartItemNotifierProvider)
                                      .items
                                      .any((element) =>
                                          element.itemsPk ==
                                          itemState.itemList![index].itemsPk)
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(cartItemNotifierProvider
                                                .notifier)
                                            .removerFromCart(
                                                itemState.itemList![index]);
                                      },
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.add_circle,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(cartItemNotifierProvider
                                                .notifier)
                                            .addtoCart(
                                                itemState.itemList![index]);
                                      },
                                    ),
                              onStepperChange: (value) {
                                itemState.itemList![index].itemQuantity = value;
                              },
                            );
                          }),
                    ),
                  )
                : itemState is ItemLoadingState
                    ? Loader(
                        size: 40,
                      )
                    : itemState is ItemErrorState
                        ? Expanded(
                            child: Column(
                              children: [
                                Constatnts().error(itemState.message),
                                IconButton(
                                    onPressed: (() => ref
                                        .read(itemNotifierProvider.notifier)
                                        .getItem(widget.categoryID,
                                            _searchController.text)),
                                    icon: const Icon(Icons.refresh_outlined))
                              ],
                            ),
                          )
                        : Container(),
          ],
        ),
      ),
    );
  }
}

class ItemCards extends StatelessWidget {
  final ItemModel item;
  final Widget? buttonWidget;
  final Function(int)? onStepperChange;
  final int steppervalue;
  final EdgeInsetsGeometry? margin;

  const ItemCards({
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
      margin:
          margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          ).wh(100, 100).px(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                '${item.itemName}'.text.bold.size(15).black.makeCentered(),
                20.heightBox,
                VxStepper(
                  actionButtonColor: AppColors.primaryColor,
                  actionIconColor: Colors.white,
                  inputTextColor: AppColors.primaryColor,
                  onChange: onStepperChange,
                  defaultValue: steppervalue,
                )
              ],
            ),
          ),
          if (buttonWidget != null) buttonWidget!
        ],
      ).pOnly(bottom: 20),
    );
  }
}
