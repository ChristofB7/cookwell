import 'package:flutter/material.dart';

import '../../db/db_provider.dart';
import '../../model/ingredient.dart';
import '../../model/shopping_item.dart';

class IngredientRow extends StatelessWidget {

  final Ingredient ingredient;
  final bool displayAddButton;

  IngredientRow({@required this.ingredient, this.displayAddButton});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ImageIcon(
            AssetImage('lib/assets/images/vegetarian.png'),
            size: 25,
          ),
        ),
        //Expanded to take up as much space as possible
        Expanded(
          child: Row(
            children: [
              Text(
                '${ingredient.amount % 1 == 0 ? ingredient.amount.toStringAsFixed(0) : ingredient.amount.toString()} ',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: colorScheme.secondary),
              ),
              //if the ignredient amount is equal to or less than 1
              ingredient.amount <= 1
                  ? Text(
                //if the ingredient unit exists then just add a space after
                '${ingredient.unit == null ? '' : ingredient.unit.toString().split('.').last + ' '}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              )
              //otherwise add an 'S' at the end for cups (if the unit exists)
                  : Text(
                '${ingredient.unit == null ? '' : ingredient.unit.toString().split('.').last + 's '}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
              Text(
                ingredient.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              ingredient.optional ? Text(
                " (optional)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ) : Text(""),
            ],
          ),
        ),
        //Sized box to adjust the size of the IconButton
        if (displayAddButton != null && displayAddButton) SizedBox(
          height: 30,
          width: 30,
          child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.local_grocery_store_outlined,
                color: colorScheme.secondary),
            onPressed: () {
              DatabaseProvider.addShoppingItem(new ShoppingItem(
                  item: ingredient.name, quantity: 0, checked: false));
              final snackBar = SnackBar(
                  content: Text('Added ${ingredient.name} to Shopping List',
                      style: TextStyle(color: colorScheme.primary)),
                  backgroundColor: colorScheme.secondary,
                  duration: const Duration(milliseconds: 500));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ),
      ],
    );
  }
}
