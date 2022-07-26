import 'package:iba/data/models/custmor_model.dart';
import 'package:iba/data/models/item_model.dart';
import 'package:iba/data/models/user_model.dart';

class OrderPlaceModel {
  List<ItemModel> items;
  User agent;
  CustmorModel custmor;
  int orderHeadPk;
  OrderPlaceModel({
    this.items = const [],
    required this.agent,
    required this.custmor,
    this.orderHeadPk = 0,
  });

  OrderPlaceModel copyWith({
    List<ItemModel>? items,
    User? agent,
    CustmorModel? custmor,
    int? orderHeadPk,
  }) {
    return OrderPlaceModel(
      items: items ?? this.items,
      agent: agent ?? this.agent,
      custmor: custmor ?? this.custmor,
      orderHeadPk: orderHeadPk ?? this.orderHeadPk,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((x) => x.toJson()).toList(),
      'agent': agent.toJson(),
      'custmor': custmor.toJson(),
      'orderHeadPk': orderHeadPk,
    };
  }

  factory OrderPlaceModel.fromJson(Map<String, dynamic> map) {
    return OrderPlaceModel(
      items: List<ItemModel>.from(
        (map['items'] as List<int>).map<ItemModel>(
          (x) => ItemModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
      agent: User.fromJson(map['agent'] as Map<String, dynamic>),
      custmor: CustmorModel.fromJson(map['custmor'] as Map<String, dynamic>),
      orderHeadPk: map['orderHeadPk'] as int,
    );
  }

  @override
  String toString() =>
      'OrderPlaceModel(items: $items, agent: $agent, custmor: $custmor ,orderHeadPk: $orderHeadPk)';
}
