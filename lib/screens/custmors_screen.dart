import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/custmor_model.dart';
import 'package:iba/data/riverpod/cart_item_notifier_provider.dart';
import 'package:iba/data/riverpod/custmors/custmors_notifier_provider.dart';
import 'package:iba/data/riverpod/custmors/custmors_state.dart';
import 'package:iba/helper/constants.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/helper/style.dart';
import 'package:iba/screens/customrs_profile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class CustmorsScreen extends ConsumerStatefulWidget {
  final int placeID;
  final bool isAddCart;
  const CustmorsScreen(
      {Key? key, required this.placeID, this.isAddCart = false})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustmorsScreenState();
}

class _CustmorsScreenState extends ConsumerState<CustmorsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref
          .read(custmorsNotifierProvider.notifier)
          .getCustmors(widget.placeID, _searchController.text);
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
    final custmorsState = ref.watch(custmorsNotifierProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
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
                    child: 'Customers'.text.bold.size(14).black.makeCentered(),
                  ),
                ],
              ),
            ).px(16),
            AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: _searchController,
              onFieldSubmitted: (value) {
                ref
                    .read(custmorsNotifierProvider.notifier)
                    .getCustmors(widget.placeID, value);
              },
              decoration: Constatnts().appInputDucoration(
                  'Search Name', AppColors.primaryColor,
                  icon: Icons.search),
            ).px(10),
            10.heightBox,
            custmorsState is CustmorsLoadedState
                ? Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      onRefresh: () async {
                        await ref
                            .read(custmorsNotifierProvider.notifier)
                            .getCustmors(
                                widget.placeID, _searchController.text);
                        _refreshController.loadComplete();
                      },
                      onLoading: () async {
                        final bool result = await ref
                            .read(custmorsNotifierProvider.notifier)
                            .getCustmorsLoadMore(
                                widget.placeID, _searchController.text);

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
                          itemCount: custmorsState.custmorsList!.length,
                          itemBuilder: (context, index) {
                            final customor = custmorsState.custmorsList![index];
                            return CustomerCards(
                              custmor: customor,
                              isAddCart: widget.isAddCart,
                              onTab: () {
                                if (widget.isAddCart) {
                                  ref
                                      .read(cartCustomNotifierProvider.notifier)
                                      .state = customor;
                                  context.pop();
                                } else {
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                          page: CustmorsProfile(
                                              custmor: customor)));
                                }
                              },
                            );
                          }),
                    ),
                  )
                : custmorsState is CustmorsLoadingState
                    ? Loader(
                        size: 40,
                      )
                    : custmorsState is CustmorsErrorState
                        ? Expanded(
                            child: Column(
                              children: [
                                Constatnts().error(custmorsState.message),
                                IconButton(
                                    onPressed: (() => ref
                                        .read(custmorsNotifierProvider.notifier)
                                        .getCustmors(widget.placeID,
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

class CustomerCards extends ConsumerWidget {
  final CustmorModel custmor;
  final void Function() onTab;
  final bool isAddCart;
  const CustomerCards({
    Key? key,
    required this.custmor,
    required this.onTab,
    this.isAddCart = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          Icon(
            Icons.person,
            size: 23,
            color: AppColors.grey,
          ).p(10).box.roundedFull.color(Colors.white).make(),
          10.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (custmor.csName ?? '').text.black.bold.size(14).make(),
                5.heightBox,
                (custmor.csName ?? '')
                    .text
                    .color(AppColors.grey)
                    .size(10)
                    .make(),
                5.heightBox,
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 20,
                    ),
                    2.widthBox,
                    Expanded(
                        child: (custmor.address ?? '')
                            .text
                            .gray600
                            .size(10)
                            .make()),
                  ],
                ),
                5.heightBox,
              ],
            ),
          ),
          if (isAddCart)
            Icon(
              Icons.navigate_next_rounded,
              size: 30,
              color: AppColors.primaryColor,
            ),
        ],
      ).pSymmetric(h: 20, v: 10),
    ).onTap(onTab);
  }
}
