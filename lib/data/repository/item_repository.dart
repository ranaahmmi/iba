import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/network/network_utils.dart';

class ItemRepository {
  int itemCategoryOffsets = 0;
  int itemOffsets = 0;
  int itemLimit = 30;

  List<ItemCategoryModel> itemCategoryList = [];
  List<ItemModel> itemList = [];

  Future<List<ItemCategoryModel>> fatchItemCategorys(String search,
      {bool loadmore = false}) async {
    if (loadmore) {
      itemCategoryOffsets += itemLimit;
    } else {
      itemCategoryOffsets = 0;
      itemCategoryList = [];
    }
    final response = await NetworkUtil().getRequest(
      api: search == ''
          ? '/principals?limit=$itemLimit&offset=$itemCategoryOffsets'
          : '/principal/$search?limit=$itemLimit&offset=$itemCategoryOffsets',
    );

    final list = List<ItemCategoryModel>.from(
      response['items'].map((x) => ItemCategoryModel.fromJson(x)),
    );
    itemCategoryList.addAll(list);
    return itemCategoryList;
  }

  Future<List<ItemModel>> fatchItem(int categoryID, String search,
      {bool loadmore = false}) async {
    if (loadmore) {
      itemOffsets += itemLimit;
    } else {
      itemOffsets = 0;
      itemList = [];
    }
    final response = await NetworkUtil().getRequest(
      api: search == ''
          ? '/items/$categoryID?limit=$itemLimit&offset=$itemOffsets'
          : '/item/$categoryID/$search?limit=$itemLimit&offset=$itemOffsets',
    );

    final list = List<ItemModel>.from(
      response['items'].map((x) => ItemModel.fromJson(x)),
    );
    itemList.addAll(list);
    return itemList;
  }
}
