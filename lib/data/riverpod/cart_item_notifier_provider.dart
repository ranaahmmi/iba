import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/interfaces/iorder_repository.dart';
import 'package:iba/data/models/custmor_model.dart';
import 'package:iba/data/models/invoice_model.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/models/order_place_model.dart';
import 'package:iba/data/models/user_model.dart';
import 'package:iba/data/repository/order_repository.dart';
import 'package:iba/helper/page_navigation_animation.dart';
import 'package:iba/screens/pdf_invoice.dart';
import 'package:iba/screens/pdf_view.dart';

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

  orderPlace(User user, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    final orderReturn = await _orderRepository.orderPlace(OrderPlaceModel(
        agent: user, custmor: state.custmor!, items: state.items));
    // Future.delayed(const Duration(seconds: 3));
    // final orderReturn = OrderPlaceModel(
    //     agent: user, custmor: state.custmor!, items: state.items);

    final date = DateTime.now();
    final dueDate = date.add(const Duration(days: 7));
    final invoice = Invoice(
      supplier: Supplier(
        name: orderReturn.agent.personName ?? 'not given',
        address: orderReturn.agent.branchName ?? 'not given',
        paymentInfo: 'PAY TO ${orderReturn.agent.personName}',
      ),
      customer: Customer(
        name: orderReturn.custmor.csName ?? 'not given',
        address: orderReturn.custmor.address ?? 'not given',
      ),
      info: InvoiceInfo(
        date: DateTime.now(),
        dueDate: dueDate,
        description: 'My description...',
        number: "INV-${orderReturn.orderHeadPk}",
      ),
      items: orderReturn.items.map((element) {
        return InvoiceItem(
          description: element.itemName ?? 'not given',
          date: DateTime.now(),
          quantity: element.itemQuantity,
          vat: 0.00,
          unitPrice: 0.00,
        );
      }).toList(),
    );

    await PdfInvoiceApi.generate(invoice)
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            SlideRightRoute(
                page: PDFScreen(
              path: value.path,
            )),
            (Route<dynamic> route) => route.isFirst));

    state = state.copyWith(isLoading: false);
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
