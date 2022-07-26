import 'package:iba/data/interfaces/iorder_repository.dart';
import 'package:iba/data/models/order_place_model.dart';
import 'package:iba/data/network/network_utils.dart';

class OrderRepository extends IOrderRepository {
  @override
  Future<OrderPlaceModel> orderPlace(OrderPlaceModel orderPlaceModel) async {
    final response = await NetworkUtil().postRequest(api: '/OrderHead', body: {
      "inventory_account_fk": orderPlaceModel.agent.branchId,
      "order_booker_fk": orderPlaceModel.agent.userId,
      "customer_fk": orderPlaceModel.custmor.cusSupPk,
      "remarks":
          "${orderPlaceModel.agent.personName} place order against ${orderPlaceModel.custmor.csName}",
    });
    for (var item in orderPlaceModel.items) {
      await NetworkUtil().postRequest(api: '/OrderDetail', body: {
        "order_head_pk": response['items'][0]['order_head_pk'],
        "item_fk": item.itemsPk,
        "quantity": item.itemQuantity,
      });
    }
    return orderPlaceModel.copyWith(orderHeadPk: response['items'][0]['order_head_pk']);
  }
}
