import 'package:iba/data/models/item_model.dart';

abstract class IitemRepository {
  Future<List<ItemCategoryModel>> fatchItemCategorys(String search,
      {bool loadmore = false});
  Future<List<ItemModel>> fatchItem(int categoryID, String search,
      {bool loadmore = false});
}
