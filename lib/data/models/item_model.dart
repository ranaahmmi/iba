class ItemCategoryModel {
  final int? distributionPk;
  final String? distributionName;

  ItemCategoryModel({
    this.distributionPk,
    this.distributionName,
  });

  ItemCategoryModel copyWith({
    int? distributionPk,
    String? distributionName,
  }) {
    return ItemCategoryModel(
      distributionPk: distributionPk ?? this.distributionPk,
      distributionName: distributionName ?? this.distributionName,
    );
  }

  ItemCategoryModel.fromJson(Map<String, dynamic> json)
      : distributionPk = json['distribution_pk'] as int?,
        distributionName = json['distribution_name'] as String?;

  Map<String, dynamic> toJson() => {
        'distribution_pk': distributionPk,
        'distribution_name': distributionName
      };
}

class ItemModel {
  final int? itemsPk;
  final String? itemName;
  final int? itemCategoryPk;
  int itemQuantity;

  ItemModel({
    this.itemsPk,
    this.itemName,
    this.itemCategoryPk,
    this.itemQuantity = 1,
  });

  ItemModel copyWith({
    int? itemsPk,
    String? itemName,
    int? itemCategoryPk,
    int? itemQuantity,
  }) {
    return ItemModel(
      itemsPk: itemsPk ?? this.itemsPk,
      itemName: itemName ?? this.itemName,
      itemCategoryPk: itemCategoryPk ?? this.itemCategoryPk,
      itemQuantity: itemQuantity ?? this.itemQuantity,
    );
  }

  ItemModel.fromJson(Map<String, dynamic> json)
      : itemsPk = json['items_pk'] as int?,
        itemName = json['item_name'] as String?,
        itemCategoryPk = json['item_category_pk'] as int?,
        itemQuantity = json['item_quantity'] ?? 1;

  Map<String, dynamic> toJson() => {
        'items_pk': itemsPk,
        'item_name': itemName,
        'item_category_pk': itemCategoryPk,
        'item_quantity': itemQuantity
      };
}
