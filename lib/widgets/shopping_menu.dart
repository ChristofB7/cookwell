import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/shopping_item.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

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
    final _quantity = quantityController.text;

    if (itemController.text.length > 2) {
      await DatabaseProvider.addShoppingItem(new ShoppingItem(
          item: _item,
          quantity: _quantity.length > 0 ? int.parse(_quantity) : 0,
          checked: false));

      setState(() {
        checkedList = DatabaseProvider.getCheckedItems();
        uncheckedList = DatabaseProvider.getUncheckedItems();
      });

      itemController.text = '';
      quantityController.text = '';
    }
  }

  void shareShoppingList(BuildContext context) async {
    await ShoppingItem.createShoppingList(context);
  }

  void _deleteAllChecked() async {
    final list = await DatabaseProvider.getCheckedItems();

    if (list != null){
      for (ShoppingItem item in list) {
        DatabaseProvider.deleteShoppingItem(item);
      }
    }

    _reload();
  }

  void _reload() {
    setState(() {
      checkedList = DatabaseProvider.getCheckedItems();
      uncheckedList = DatabaseProvider.getUncheckedItems();
    });
  }

  void _openNumberPicker() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:  Text("Quantity"),
        content:  StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 200,
                child: Center(
                  child: NumberPicker.integer(
                    initialValue: quantityController.text == "" ? 0 : int.parse(
                        quantityController.text),
                    minValue: 0,
                    maxValue: 10,
                    onChanged: (newValue) =>
                        setState(() =>
                        quantityController.text = newValue.toString()),),
                ),
              );
            },),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<ShoppingItem>>(
              future: DatabaseProvider.getUncheckedItems(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ShoppingItem>> snapshot) {
                return snapshot.hasData
                    ? Column(
                        children: snapshot.data
                            .map((item) => buildItem(item, colorScheme, false))
                            .toList())
                    : SizedBox();
              },
            ),
            newItem(colorScheme),
            Row(
              children: [
                Text("COMPLETED"),
                IconButton(
                  icon: Icon(Icons.ios_share),
                  onPressed: () {
                    shareShoppingList(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteAllChecked(),
                ),
              ],
            ),
            FutureBuilder<List<ShoppingItem>>(
              future: DatabaseProvider.getCheckedItems(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ShoppingItem>> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      children: snapshot.data
                          .map((item) => buildItem(item, colorScheme, true))
                          .toList());
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

  Dismissible buildItem(
      ShoppingItem item, ColorScheme colorScheme, bool checked) {
    return Dismissible(
      key: Key(item.item + item.id.toString()),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            DatabaseProvider.deleteShoppingItem(item);
          });
          return true;
        } else
          return false;
      },
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        setState(() {
          DatabaseProvider.deleteShoppingItem(item);
          checkedList = DatabaseProvider.getCheckedItems();
          uncheckedList = DatabaseProvider.getUncheckedItems();
        });
      },
      child: Card(
        child: CheckboxListTile(
          title: Row(
            children: [
              Text(
                "${item.item} ",
                style: checked
                    ? TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              Text(
                item.quantity != 0 ? "(${item.quantity})" : "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: checked ? TextDecoration.lineThrough : null),
              ),
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
          value: item.checked,
          onChanged: (bool value) {
            DatabaseProvider.toggleItem(item);
            setState(() {
              checkedList = DatabaseProvider.getCheckedItems();
              uncheckedList = DatabaseProvider.getUncheckedItems();
            });
          },
          activeColor: colorScheme.primary,
          checkColor: colorScheme.primaryVariant,
        ),
      ),
    );
  }

  Card newItem(ColorScheme colorScheme) {
    return Card(
      child: ListTile(
        leading: IconButton(icon: Icon(Icons.add), onPressed: _submitData),
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
            FlatButton(
                color: Colors.white,
                textColor: colorScheme.primary,
                padding: EdgeInsets.all(8.0),
                onPressed: _openNumberPicker,
                child: Text(
                  quantityController.text == "" ? "QUANTITY" : quantityController.text == "0" ? "QUANTITY" : quantityController.text,
                  style: TextStyle(fontSize: 20.0),
                ),
            ),
            ],
        ),
      ),
    );
  }
}
