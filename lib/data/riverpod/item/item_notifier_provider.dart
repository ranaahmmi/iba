import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/repository/item_repository.dart';
import 'package:iba/data/riverpod/item/item_categories_notifier_provider.dart';

final itemNotifierProvider =
    StateNotifierProvider<ItemNotifier, ItemState>((ref) {
  return ItemNotifier(ref.watch(itemRepositoryProvider));
});

class ItemNotifier extends StateNotifier<ItemState> {
  final ItemRepository _itemRepository;

  ItemNotifier(this._itemRepository) : super(const InitalItemState());

  Future<bool> getItem(int categoryID,String search) async {
    try {
      state = const ItemLoadingState();
      final items =
          await _itemRepository.fatchItem(categoryID,search, loadmore: false);
      state = ItemLoadedState(items);
      return true;
    } catch (e) {
      state = ItemErrorState(e.toString());
      return false;
    }
  }

  Future<bool> getItemLoadMore(int categoryID,String search) async {
    try {
      final _items =
          await _itemRepository.fatchItem(categoryID,search, loadmore: true);
      state = ItemLoadedState(_items);
      return true;
    } catch (e) {
      state = ItemErrorState(e.toString());
      return false;
    }
  }
}

abstract class ItemState {
  const ItemState();
}

class InitalItemState extends ItemState {
  const InitalItemState();
}

class ItemLoadingState extends ItemState {
  const ItemLoadingState();
}

class ItemLoadedState extends ItemState {
  final List<ItemModel>? itemList;
  const ItemLoadedState(this.itemList);
}

class ItemErrorState extends ItemState {
  final String message;
  const ItemErrorState(this.message);
}
