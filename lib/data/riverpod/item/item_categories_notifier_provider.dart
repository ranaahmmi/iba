
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/repository/item_repository.dart';

final itemRepositoryProvider = Provider((ref) => ItemRepository());

final itemCategoryNotifierProvider =
    StateNotifierProvider<ItemCategoyNotifier, ItemCategoryState>((ref) {
  return ItemCategoyNotifier(ref.watch(itemRepositoryProvider));
});


class ItemCategoyNotifier extends StateNotifier<ItemCategoryState> {
  final ItemRepository _itemCategoryRepository;

  ItemCategoyNotifier(this._itemCategoryRepository)
      : super(const InitalItemCategoryState());

  Future<bool> getItemCategory() async {
    try {
      state = const ItemCategoryLoadingState();
      final itemCategory =
          await _itemCategoryRepository.fatchItemCategorys(loadmore: false);
      state = ItemCategoryLoadedState(itemCategory);
      return true;
    } catch (e) {
      state = ItemCategoryErrorState(e.toString());
      return false;
    }
  }

  Future<bool> getItemCategoryLoadMore() async {
    try {
      final _itemCategory =
          await _itemCategoryRepository.fatchItemCategorys( loadmore: true);
      state = ItemCategoryLoadedState(_itemCategory);
      return true;
    } catch (e) {
      state = ItemCategoryErrorState(e.toString());
      return false;
    }
  }
}


abstract class ItemCategoryState {
  const ItemCategoryState();
}

class InitalItemCategoryState extends ItemCategoryState {
  const InitalItemCategoryState();
}

class ItemCategoryLoadingState extends ItemCategoryState {
  const ItemCategoryLoadingState();
}

class ItemCategoryLoadedState extends ItemCategoryState {
  final List<ItemCategoryModel>? itemCategoryList;
  const ItemCategoryLoadedState(this.itemCategoryList);
}

class ItemCategoryErrorState extends ItemCategoryState {
  final String message;
  const ItemCategoryErrorState(this.message);
}