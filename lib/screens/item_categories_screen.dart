import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/riverpod/item/item_categories_notifier_provider.dart';
import 'package:iba/helper/constants.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/helper/style.dart';
import 'package:iba/screens/item_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemCategoriesScreen extends ConsumerStatefulWidget {
  const ItemCategoriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ItemCategoriesScreenState();
}

class _ItemCategoriesScreenState extends ConsumerState<ItemCategoriesScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(itemCategoryNotifierProvider.notifier).getItemCategory();
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
    final itemCategoryState = ref.watch(itemCategoryNotifierProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              child: Stack(
                children: [
                  const Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: 'Item Categories'
                        .text
                        .bold
                        .size(14)
                        .black
                        .makeCentered(),
                  ),
                ],
              ),
            ).px(16),
            AppTextField(
              textFieldType: TextFieldType.NAME,
              decoration: Constatnts().appInputDucoration(
                  'Search Categories', AppColors.primaryColor,
                  icon: Icons.search),
            ).px(10),
            10.heightBox,
            itemCategoryState is ItemCategoryLoadedState
                ? Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      onRefresh: () async {
                        await ref
                            .read(itemCategoryNotifierProvider.notifier)
                            .getItemCategory();
                        _refreshController.loadComplete();
                      },
                      onLoading: () async {
                        final bool result = await ref
                            .read(itemCategoryNotifierProvider.notifier)
                            .getItemCategoryLoadMore();

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
                          itemCount: itemCategoryState.itemCategoryList!.length,
                          itemBuilder: (context, index) {
                            return ItemCategoryCards(
                                itemCategory:
                                    itemCategoryState.itemCategoryList![index]);
                          }),
                    ),
                  )
                : itemCategoryState is ItemCategoryLoadingState
                    ? Loader(
                        size: 40,
                      )
                    : itemCategoryState is ItemCategoryErrorState
                        ? Expanded(
                            child: Column(
                              children: [
                                Constatnts().error(itemCategoryState.message),
                                IconButton(
                                    onPressed: (() => ref
                                        .read(itemCategoryNotifierProvider
                                            .notifier)
                                        .getItemCategory()),
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

class ItemCategoryCards extends StatelessWidget {
  final ItemCategoryModel itemCategory;
  const ItemCategoryCards({
    Key? key,
    required this.itemCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl:
                  "https://www.foodnavigator-asia.com/var/wrbm_gb_food_pharma/storage/images/_aliases/news_large/3/1/0/1/171013-1-eng-GB/1.-Moutai.jpg",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Divider(
            color: AppColors.primaryColor,
            thickness: 1,
          ),
          10.heightBox,
          '${itemCategory.distributionName}'
              .text
              .bold
              .size(15)
              .black
              .makeCentered(),
        ],
      ).pOnly(bottom: 20),
    ).onTap(() {
      Navigator.push(
          context,
          SlideRightRoute(
              page: ItemsScreen(
            categoryID: itemCategory.distributionPk!,
          )));
    });
  }
}
