import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/ingredient.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookwell/model/shopping_item.dart';

class ViewRecipe extends StatefulWidget {
  @override
  _ViewRecipeState createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  Recipe recipe;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    recipe = ModalRoute.of(context).settings.arguments as Recipe;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: colorScheme.primary,
            leading: Container(),
            pinned: false,
            expandedHeight: 210,
            flexibleSpace: FlexibleSpaceBar(
              background: _createCard(recipe, colorScheme, context),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // a stack allows us to put the back iconbutton and the favorite icon button ontop of the image
                    Divider(
                      color: colorScheme.surface,
                      thickness: 3,
                      indent: 40,
                      endIndent: 40,
                    ),
                    _createHeader("INGREDIENTS", colorScheme, textTheme),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recipe.ingredients
                          .map((ingredient) => _createIngredientRow(
                              ingredient, colorScheme, context))
                          .toList(),
                    ),
                    _createHeader("DIRECTIONS", colorScheme, textTheme),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recipe.directions
                          .asMap()
                          .entries
                          .map(
                            (direction) => Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${direction.key + 1}. ${direction.value}',
                                style: textTheme.caption,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    _createHeader("NOTES", colorScheme, textTheme),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${recipe.notes == null ? '\n\n' : recipe.notes}',
                        style: textTheme.caption,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack _createCard(
      Recipe recipe, ColorScheme colorScheme, BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: colorScheme.primary,
                image: DecorationImage(
                    image: recipe.image != null
                        ? recipe.image.image
                        : AssetImage('lib/assets/images/vegetarian.png'),
                    fit: BoxFit.cover)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //BACK ICON button
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: colorScheme.secondary,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context, true),
              color: Colors.white,
            ),
            IconButton(
              icon: recipe.saved
                  ? Icon(
                      Icons.favorite,
                      color: colorScheme.secondary,
                      size: 30,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: colorScheme.secondary,
                      size: 30,
                    ),
              onPressed: () {
                setState(() {
                  if (recipe.saved) {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Remove Recipe"),
                              content: Text(
                                  "Are you sure you would like to remove this recipe from MyCookbook?"),
                              actions: [
                                TextButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      DatabaseProvider.deleteRecipe(recipe);
                                    });
                                    if (recipe.saved) {
                                      final snackBar = SnackBar(
                                          content: Text(
                                            'Removed from MyCookbook',
                                            style: TextStyle(
                                                color: colorScheme.primary),
                                          ),
                                          backgroundColor:
                                              colorScheme.secondary,
                                          duration: const Duration(
                                              milliseconds: 500));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
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
                            ));
                  } else {
                    DatabaseProvider.addRecipe(recipe);
                    if (!recipe.saved) {
                      final snackBar = SnackBar(
                          content: Text(
                            'Added to MyCookbook',
                            style: TextStyle(color: colorScheme.primary),
                          ),
                          backgroundColor: colorScheme.secondary,
                          duration: const Duration(milliseconds: 500));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                });
                recipe.saved = !recipe.saved;
              },
              color: Colors.white,
            )
          ],
        ),
        Positioned(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: _createDetailCard(colorScheme),
          ),
        ),
      ],
    );
  }

  Column _createHeader(
      String header, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
          child: Text(
            header,
            style: textTheme.headline6,
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

  Card _createDetailCard(ColorScheme colorScheme) {
    return Card(
      color: colorScheme.secondary.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 1,
                child: (recipe.servingSize == 1)
                    ? Icon(Icons.person_outline, color: colorScheme.primary)
                    : Icon(Icons.people_outline, color: colorScheme.primary)),
            Flexible(
              flex: 2,
              child: Text(
                  'serving size: ${recipe.servingSize.toStringAsFixed(0)} ${(recipe.servingSize == 1) ? "person" : "people"}',
                  style: TextStyle(color: colorScheme.primary)),
            ),
            Flexible(
                flex: 1,
                child: Icon(
                  Icons.av_timer,
                  color: colorScheme.primary,
                )),
            Flexible(
              flex: 2,
              child: Text('prep time: \n${recipe.prepTime.inMinutes} minutes',
                  style: TextStyle(color: colorScheme.primary)),
            ),
            Flexible(
                flex: 1,
                child: Icon(Icons.access_time, color: colorScheme.primary)),
            Flexible(
              flex: 2,
              child: Text(
                  'cook time: \n${recipe.cookingTime.inMinutes} minutes',
                  style: TextStyle(color: colorScheme.primary)),
            ),
          ],
        ),
      ),
    );
  }

  Row _createIngredientRow(
      Ingredient ingredient, ColorScheme colorScheme, BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          // Icon made by https://www.flaticon.com/authors/eucalyp Eucalyp.
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
            ],
          ),
        ),
        //Sized box to adjust the size of the IconButton
        SizedBox(
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
        )
      ],
    );
  }
}
