import 'package:cookwell/model/dummy_shopping.dart';
import 'package:cookwell/model/shopping_item.dart';
import 'package:flutter/material.dart';

class ShoppingMenu extends StatefulWidget {
  ShoppingMenu();

  @override
  State<StatefulWidget> createState() => _ShoppingMenuState();
}

class _ShoppingMenuState extends State<ShoppingMenu> {
  final itemController = TextEditingController();
  final quantityController = TextEditingController();

  void _submitData() {
    final _item = itemController.text;
    final _quantity = int.parse(quantityController.text);

    setState(() {
      dummy_shopping.add(new ShoppingItem(name: _item, quantity: _quantity, checked: 'false'));
    });

    itemController.text = '';

  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    quantityController.text = '1';

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: dummy_shopping
                  .where((i) => i.checked == 'false')
                  .map(
                    (item) => GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: CheckboxListTile(
                          title: Text("${item.name} (${item.quantity})"),
                          secondary: Icon(Icons.more_vert),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: item.checked == "true" ? true : false,
                          onChanged: (bool value) {
                            setState(() {
                              item.checked = value.toString();
                            });
                          },
                          activeColor: colorScheme.primary,
                          checkColor: colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Card(
              child: ListTile(
                leading: IconButton(icon: Icon(Icons.add), onPressed: _submitData),
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(child: TextField(
                      controller: itemController,
                      onSubmitted: (_) => _submitData,
                      decoration: InputDecoration(
                        labelText: 'New Item',
                      ),),),
                    Container(
                      width: 50,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,),
                      ),
                    ),
                  ],
                ),
                //trailing: Icon(Icons.check),
              ),
            ),
            Text('completed'),
            ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: dummy_shopping
                  .where((i) => i.checked == 'true')
                  .map(
                    (item) => GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: CheckboxListTile(
                          title: Text(
                            "${item.name} (${item.quantity})",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough),
                          ),
                          secondary: Icon(Icons.more_vert),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: item.checked == "true" ? true : false,
                          onChanged: (bool value) {
                            setState(() {
                              item.checked = value.toString();
                            });
                          },
                          activeColor: colorScheme.primary,
                          checkColor: colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
