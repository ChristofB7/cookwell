import 'package:cookwell/db/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:share/share.dart';

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
    DatabaseProvider.COLUMN_SHOP_ID: id,
    DatabaseProvider.COLUMN_ITEM: item,
    DatabaseProvider.COLUMN_CHECKED: checked ? 1 : 0,
    DatabaseProvider.COLUMN_QUANTITY: quantity,
    };

  ShoppingItem.fromMap(Map<String, dynamic> map)   {
    id = map[DatabaseProvider.COLUMN_SHOP_ID];
    item = map[DatabaseProvider.COLUMN_ITEM];
    quantity = map[DatabaseProvider.COLUMN_QUANTITY];
    checked = map[DatabaseProvider.COLUMN_CHECKED] == 1;
  }

  static Future<void> createShoppingList(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    List<ShoppingItem> list = await DatabaseProvider.getUncheckedItems();
    String sharableList = "";

    if (list != null) {
      for (ShoppingItem item in list) {
        sharableList += item.toString();
      }
      Share.share(sharableList,
          subject: "Shopping List\n",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  String toString(){
    return ("${this.item} ${this.quantity == 0 ? "" : "(${this.quantity})"}\n");
  }

}
