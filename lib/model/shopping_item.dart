import 'package:cookwell/db/shopping_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ShoppingItem {
  int id;
  String item;
  int quantity;
  bool checked;

  ShoppingItem({this.id,
    @required this.item,
    @required this.quantity,
    @required this.checked,
  });

  Map<String, dynamic> toMap() =>{
    ShoppingDatabaseProvider.COLUMN_ID: id,
    ShoppingDatabaseProvider.COLUMN_ITEM: item,
    ShoppingDatabaseProvider.COLUMN_CHECKED: checked ? 1 : 0,
    ShoppingDatabaseProvider.COLUMN_QUANTITY: quantity,
    };

  ShoppingItem.fromMap(Map<String, dynamic> map)   {
    id = map[ShoppingDatabaseProvider.COLUMN_ID];
    item = map[ShoppingDatabaseProvider.COLUMN_ITEM];
    quantity = map[ShoppingDatabaseProvider.COLUMN_QUANTITY];
    checked = map[ShoppingDatabaseProvider.COLUMN_CHECKED] == 1;
  }

}
