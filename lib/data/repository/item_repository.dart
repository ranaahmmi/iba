import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/network/network_utils.dart';

class ItemRepository {
  int itemCategorypage = 0;
    int itempage = 0;

  List<ItemCategoryModel> itemCategoryList = [];
    List<ItemModel> itemList = [];


  Future<List<ItemCategoryModel>> fatchItemCategorys(
      {bool loadmore = false}) async {
    if (loadmore) {
      itemCategorypage++;
    } else {
      itemCategorypage = 0;
      itemCategoryList = [];
    }
    final response = await NetworkUtil().getRequest(
      api: '/principals?limit=30&offset=$itemCategorypage',
    );

    final list = List<ItemCategoryModel>.from(
      response['items'].map((x) => ItemCategoryModel.fromJson(x)),
    );
    itemCategoryList.addAll(list);
    return itemCategoryList;
  }


    Future<List<ItemModel>> fatchItem(int categoryID,
      {bool loadmore = false}) async {
    if (loadmore) {
      itempage++;
    } else {
      itempage = 0;
      itemList = [];
    }
    final response = await NetworkUtil().getRequest(
      api: '/items/$categoryID?limit=30&offset=$itempage',
    );

    final list = List<ItemModel>.from(
      response['items'].map((x) => ItemModel.fromJson(x)),
    );
    itemList.addAll(list);
    return itemList;
  }
  
}