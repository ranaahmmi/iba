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

  ItemModel({
    this.itemsPk,
    this.itemName,
  });

  ItemModel copyWith({
    int? itemsPk,
    String? itemName,
  }) {
    return ItemModel(
      itemsPk: itemsPk ?? this.itemsPk,
      itemName: itemName ?? this.itemName,
    );
  }

  ItemModel.fromJson(Map<String, dynamic> json)
      : itemsPk = json['items_pk'] as int?,
        itemName = json['item_name'] as String?;

  Map<String, dynamic> toJson() => {'items_pk': itemsPk, 'item_name': itemName};
}
