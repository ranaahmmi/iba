import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/models/item_model.dart';

final cartItemNotifierProvider =
    StateNotifierProvider<CartItemNotifier, List<ItemModel>>((ref) {
  return CartItemNotifier();
});

class CartItemNotifier extends StateNotifier<List<ItemModel>> {
  CartItemNotifier() : super([]);
  addtoCart(ItemModel item) {
    state = state.toList()..add(item);
  }

  removerFromCart(ItemModel item) {
    final int index =
        state.indexWhere((element) => element.itemsPk == item.itemsPk);
    state = state.toList()..removeAt(index);
  }

  clearCart() {
    state = [];
  }

  addQuantity(ItemModel item, int quantity) {
    int index = state.indexOf(item);
    state = state.toList()..removeAt(index);
    item.itemQuantity=quantity;
    state = state.toList()..insert(index, item);
  }

 
}
