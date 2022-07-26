import 'package:iba/data/models/order_place_model.dart';

abstract class IOrderRepository {
  Future<OrderPlaceModel> orderPlace(OrderPlaceModel orderPlaceModel);
}
