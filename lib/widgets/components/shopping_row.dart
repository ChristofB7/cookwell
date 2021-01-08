import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/shopping_item.dart';
import 'package:flutter/material.dart';

class ShoppingItemRow extends StatelessWidget {

  final ShoppingItem item;
  final bool checked;
  final Function reloadParentState;

  ShoppingItemRow ({@required this.item, @required this.checked, @required this.reloadParentState});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
        key: Key(item.item + item.id.toString()),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            DatabaseProvider.deleteShoppingItem(item);
            reloadParentState();
            return true;
          } else
            return false;
        },
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          DatabaseProvider.deleteShoppingItem(item);
          reloadParentState();
        },
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: item.checked,
                  onChanged: (_) {
                    DatabaseProvider.toggleItem(item);
                    reloadParentState();
                  },
                  activeColor: colorScheme.primary,
                  checkColor: colorScheme.primary,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "${item.item} ",
                        style: TextStyle(
                            fontSize: 14,
                            decoration:
                            checked ? TextDecoration.lineThrough : null),
                      ),
                      Text(
                        item.quantity != 0 ? "(${item.quantity})" : "",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration:
                            checked ? TextDecoration.lineThrough : null),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

}
