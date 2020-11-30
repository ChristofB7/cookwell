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
    if (list != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Delete Checked Items"),
          content:
              Text("Are you sure you would like to delete all checked items?"),
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

  void _openNumberPicker(TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Quantity",
          style: textTheme.headline6,
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 200,
              child: Center(
                child: NumberPicker.integer(
                  initialValue: quantityController.text == ""
                      ? 0
                      : int.parse(quantityController.text),
                  minValue: 0,
                  maxValue: 10,
                  onChanged: (newValue) => setState(
                      () => quantityController.text = newValue.toString()),
                  selectedTextStyle: textTheme.headline5,
                  textStyle: textTheme.bodyText1,
                ),
              ),
            );
          },
        ),
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
            _createHeader(
              "MY LIST",
              colorScheme,
              textTheme,
              IconButton(
                icon: Icon(
                  Icons.ios_share,
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  shareShoppingList(context);
                },
              ),
            ),
            FutureBuilder<List<ShoppingItem>>(
              future: DatabaseProvider.getUncheckedItems(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ShoppingItem>> snapshot) {
                return snapshot.hasData
                    ? Column(
                        children: snapshot.data
                            .map((item) =>
                                _buildItem(item, colorScheme, textTheme, false))
                            .toList())
                    : SizedBox();
              },
            ),
            _newItem(colorScheme, textTheme),
            _createHeader(
              "COMPLETED",
              colorScheme,
              textTheme,
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: colorScheme.primary,
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
                              _buildItem(item, colorScheme, textTheme, true))
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

  Dismissible _buildItem(ShoppingItem item, ColorScheme colorScheme,
      TextTheme textTheme, bool checked) {
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
      direction: DismissDirection.endToStart,
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        setState(() {
          DatabaseProvider.deleteShoppingItem(item);
          checkedList = DatabaseProvider.getCheckedItems();
          uncheckedList = DatabaseProvider.getUncheckedItems();
        });
      },
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Row(
            children: <Widget>[
              Checkbox(
                value: item.checked,
                onChanged: (bool value) {
                  DatabaseProvider.toggleItem(item);
                  setState(() {
                    checkedList = DatabaseProvider.getCheckedItems();
                    uncheckedList = DatabaseProvider.getUncheckedItems();
                  });
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

  Card _newItem(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.secondary, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
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
              onPressed: () => _openNumberPicker(textTheme),
              child: quantityController.text == ""
                  ? Text(
                      "QUANTITY",
                      style: TextStyle(fontSize: 12.0),
                    )
                  : quantityController.text == "0"
                      ? Text(
                          "QUANTITY",
                          style: TextStyle(fontSize: 12.0),
                        )
                      : Text(
                          quantityController.text,
                          style: TextStyle(fontSize: 20.0),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Column _createHeader(String header, ColorScheme colorScheme,
      TextTheme textTheme, IconButton icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  header,
                  style: textTheme.headline6,
                ),
              ),
              icon,
            ],
          ),
        ),
        Divider(
          color: colorScheme.secondary,
          height: 10,
          thickness: 1,
          indent: 3,
          endIndent: 3,
        ),
      ],
    );
  }
}
