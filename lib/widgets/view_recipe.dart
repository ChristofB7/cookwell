import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:cookwell/widgets/components/recipe_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/direction_row.dart';
import 'components/header.dart';
import 'components/ingredient_row.dart';

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
        body: SafeArea(
          child: CustomScrollView(
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
                        Header(header: "INGREDIENTS"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recipe.ingredients
                              .map((ingredient) => IngredientRow(ingredient: ingredient, displayAddButton: true,))
                              .toList(),
                        ),
                        Header(header: "DIRECTIONS"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recipe.directions
                              .asMap()
                              .entries
                              .map((direction) => DirectionRow(step: direction.key + 1, direction: direction.value))
                              .toList(),
                        ),
                        Header(header: "NOTES"),
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
              onPressed: () {ScaffoldMessenger.of(context).removeCurrentSnackBar(); Navigator.pop(context, true);},
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
            child: RecipeDetailCard(recipe: recipe,),
          ),
        ),
      ],
    );
  }
}
