import 'package:cookwell/db/shopping_db_provider.dart';
import 'package:cookwell/model/shopping_item.dart';
import 'package:flutter/material.dart';

class ShoppingMenu extends StatefulWidget {
  ShoppingMenu();

  @override
  State<StatefulWidget> createState() => _ShoppingMenuState();
}

class _ShoppingMenuState extends State<ShoppingMenu> {
  Future<List<ShoppingItem>> checkedList;
  Future<List<ShoppingItem>> uncheckedList;

  final itemController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  void _submitData() async {
    final _item = itemController.text;
    final _quantity = int.parse(quantityController.text);

    await ShoppingDatabaseProvider.addShoppingItem(new ShoppingItem(item: _item, quantity: _quantity, checked: false));
    setState(() {
      checkedList = ShoppingDatabaseProvider.getCheckedItems();
      uncheckedList = ShoppingDatabaseProvider.getUncheckedItems();
    });

    itemController.text = '';
    quantityController.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    itemController.text = "";
    quantityController.text = '1';

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [FutureBuilder<List<ShoppingItem>>(
                  future: ShoppingDatabaseProvider.getUncheckedItems(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ShoppingItem>> snapshot) {
                    if (snapshot.hasData) {
                      return Column(children: snapshot.data.map((item) => buildItem(item, colorScheme, false)).toList());
                    } else {
                      return SizedBox();
                    }
                  },
              ),
              Card(
                child: ListTile(
                  leading:
                      IconButton(icon: Icon(Icons.add), onPressed: _submitData),
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: TextField(
                          controller: itemController,
                          onSubmitted: (_) => _submitData,
                          decoration: InputDecoration(
                            labelText: 'New Item',
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            onSubmitted: (_) => _submitData,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //trailing: Icon(Icons.check),
                ),
              ),
              Text('completed'),
              FutureBuilder<List<ShoppingItem>>(
                future: ShoppingDatabaseProvider.getCheckedItems(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ShoppingItem>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: snapshot.data.map((item) => buildItem(item, colorScheme, true)).toList());
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
    );
  }

  Dismissible buildItem(ShoppingItem item, ColorScheme colorScheme, bool checked) {
    return Dismissible(
        key: Key(item.item),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            ShoppingDatabaseProvider.deleteShoppingItem(item);
            checkedList = ShoppingDatabaseProvider.getCheckedItems();
            uncheckedList = ShoppingDatabaseProvider.getUncheckedItems();
          });
          return true;
        } else
          return false;
      },
      background: Container(color: Colors.red),
      onDismissed: (direction) {
          setState(() {
            ShoppingDatabaseProvider.deleteShoppingItem(item);
            checkedList = ShoppingDatabaseProvider.getCheckedItems();
              uncheckedList = ShoppingDatabaseProvider.getUncheckedItems();
          });
          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text("$item dismissed")));
        },
      child: Card(
        child: CheckboxListTile(
          title: Text("${item.item} (${item.quantity})",  style: checked ? TextStyle(
              decoration: TextDecoration.lineThrough) : null,),
          secondary: Icon(Icons.more_vert),
          controlAffinity: ListTileControlAffinity.leading,
          value: item.checked,
          onChanged: (bool value) {
            ShoppingDatabaseProvider.toggleItem(item);
            setState(() {
              checkedList = ShoppingDatabaseProvider.getCheckedItems();
              uncheckedList = ShoppingDatabaseProvider.getUncheckedItems();
            });
          },
          activeColor: colorScheme.primary,
          checkColor: colorScheme.primaryVariant,
        ),
      ),
    );
  }
}
