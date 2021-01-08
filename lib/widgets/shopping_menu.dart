import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/shopping_item.dart';
import 'package:flutter/material.dart';

import 'components/header.dart';
import 'components/shopping_row.dart';

class ShoppingMenu extends StatefulWidget {
  ShoppingMenu();

  @override
  State<StatefulWidget> createState() => _ShoppingMenuState();
}

class _ShoppingMenuState extends State<ShoppingMenu> {
  Future<List<ShoppingItem>> checkedList;
  Future<List<ShoppingItem>> uncheckedList;

  FocusNode _newItemFocusNode = FocusNode();

  final itemController = TextEditingController();
  final quantityController = TextEditingController();

  void _submitData() async {
    final _item = itemController.text;

    if (itemController.text.length > 2) {
      await DatabaseProvider.addShoppingItem(
          ShoppingItem.parseShoppingItem(_item));

      setState(() {
        checkedList = DatabaseProvider.getCheckedItems();
        uncheckedList = DatabaseProvider.getUncheckedItems();
      });

      itemController.text = '';
    }
  }

  void shareShoppingList(BuildContext context) async {
    await ShoppingItem.createShoppingList(context);
  }

  void _deleteAllChecked() async {
    final list = await DatabaseProvider.getCheckedItems();
    if (list != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Delete all checked items?"),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  for (ShoppingItem item in list) {
                    DatabaseProvider.deleteShoppingItem(item);
                  }
                });
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        ),
      );
    }
    _reload();
  }

  void _reload() {
    setState(() {
      checkedList = DatabaseProvider.getCheckedItems();
      uncheckedList = DatabaseProvider.getUncheckedItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                header: 'MY LIST',
                icon: IconButton(
                  icon: Icon(Icons.ios_share),
                  onPressed: () => shareShoppingList(context),
                ),
              ),
              FutureBuilder<List<ShoppingItem>>(
                future: DatabaseProvider.getUncheckedItems(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ShoppingItem>> snapshot) {
                  return snapshot.hasData
                      ? Column(
                          children: snapshot.data
                              .map((item) => ShoppingItemRow(
                                  item: item, checked: false, reloadParentState: _reload))
                              .toList())
                      : SizedBox();
                },
              ),
              _newItem(colorScheme, textTheme),
              Header(
                header: 'COMPLETED',
                icon: IconButton(
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: () => _deleteAllChecked(),
                ),
              ),
              FutureBuilder<List<ShoppingItem>>(
                future: DatabaseProvider.getCheckedItems(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ShoppingItem>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        children: snapshot.data
                            .map((item) =>
                            ShoppingItemRow(
                                item: item, checked: true, reloadParentState: _reload))
                            .toList());
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _newItem(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.secondary, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Color(0x00000000),
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: _submitData,
          color: colorScheme.primary,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: TextField(
                  controller: itemController,
                  decoration: InputDecoration(
                    labelText: 'New Item',
                  ),
                  textInputAction: TextInputAction.done,
                  focusNode: _newItemFocusNode,
                  onSubmitted: (_) => _submitData,
                  onEditingComplete: _submitData),
            ),
          ],
        ),
      ),
    );
  }
}
