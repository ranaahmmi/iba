import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/interfaces/iorder_repository.dart';
import 'package:iba/data/models/custmor_model.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/models/order_place_model.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/data/repository/order_repository.dart';

final cartItemNotifierProvider =
    StateNotifierProvider<CartItemNotifier, CartItemState>((ref) {
  return CartItemNotifier(ref.read(orderRepositoryProvider));
});

final orderRepositoryProvider =
    Provider<IOrderRepository>((ref) => OrderRepository());

class CartItemNotifier extends StateNotifier<CartItemState> {
  final IOrderRepository _orderRepository;
  CartItemNotifier(this._orderRepository) : super(const CartItemState());
  addtoCart(ItemModel item) {
    state = state.copyWith(
      items: state.items.toList()..add(item),
    );
  }

  addcustomer(CustmorModel custmor) {
    state = state.copyWith(
      custmor: Wrapped.value(custmor),
    );
  }

  removeCustomer() {
    print('customer removed');
    state = state.copyWith(custmor: const Wrapped.value(null));
  }

  removerFromCart(ItemModel item) {
    final int index =
        state.items.indexWhere((element) => element.itemsPk == item.itemsPk);
    state = state.copyWith(items: state.items.toList()..removeAt(index));
  }

  clearCart() {
    state = state.copyWith(items: [], custmor: const Wrapped.value(null));
  }

  addQuantity(ItemModel item, int quantity) {
    int index = state.items.indexOf(item);
    state = state.copyWith(items: state.items..removeAt(index));
    item.itemQuantity = quantity;
    state = state.copyWith(items: state.items..insert(index, item));
  }

  Future<OrderPlaceModel> orderPlace(User user) async {
    state = state.copyWith(isLoading: true);
    // final orderReturn = await _orderRepository.orderPlace(OrderPlaceModel(
    //     agent: user, custmor: state.custmor!, items: state.items));
    Future.delayed(const Duration(seconds: 3));
    state = state.copyWith(isLoading: false);
    // return orderReturn;
    return OrderPlaceModel(
        agent: user, custmor: state.custmor!, items: state.items);
  }
}

class CartItemState {
  final CustmorModel? custmor;
  final List<ItemModel> items;
  final bool isloading;
  const CartItemState(
      {this.custmor, this.items = const [], this.isloading = false});

  CartItemState copyWith({
    Wrapped<CustmorModel?>? custmor,
    List<ItemModel>? items,
    bool? isLoading,
  }) {
    return CartItemState(
      custmor: custmor != null ? custmor.value : this.custmor,
      items: items ?? this.items,
      isloading: isLoading ?? isloading,
    );
  }
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
