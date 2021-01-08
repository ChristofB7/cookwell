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
    DatabaseProvider.COLUMN_ID: id,
    DatabaseProvider.COLUMN_NAME: item,
    DatabaseProvider.COLUMN_CHECKED: checked ? 1 : 0,
    DatabaseProvider.COLUMN_QUANTITY: quantity,
    };

  ShoppingItem.fromMap(Map<String, dynamic> map)   {
    id = map[DatabaseProvider.COLUMN_ID];
    item = map[DatabaseProvider.COLUMN_NAME];
    quantity = map[DatabaseProvider.COLUMN_QUANTITY];
    checked = map[DatabaseProvider.COLUMN_CHECKED] == 1;
  }

  static Future<void> createShoppingList(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    List<ShoppingItem> list = await DatabaseProvider.getUncheckedItems();
    String sharableList = "Shopping List";

    //TODO: adjustable shopping list header
    if (list != null) {
      for (ShoppingItem item in list) {
        sharableList += item.toString();
      }
      Share.share(sharableList,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  String toString(){
    return ("\n${this.item} ${this.quantity == 0 ? "" : "(${this.quantity})"}");
  }

  static ShoppingItem parseShoppingItem(String input) {
    List inputs = input.split(' ');

    if (num.tryParse(inputs[0]) != null) {
      String item = inputs.sublist(1).join(' ').trim();
      int amount = num.tryParse(inputs[0]).toInt();
      return ShoppingItem(item: item, quantity: amount, checked: false);
    } else {
      return ShoppingItem(item: input, quantity: 0, checked: false);
    }
  }
}
