import 'package:cookwell/model/recipe.dart';
import 'header.dart';
import 'recipe_tile.dart';
import 'package:cookwell/widgets/recipes_menu.dart';
import 'package:cookwell/interfaces/stateful_menu.dart';
import 'package:flutter/material.dart';

class VerticalRecipesList extends StatelessWidget {
  final Future<List<Recipe>> list;
  final StatefulMenu state;
  final String header;

  VerticalRecipesList({@required this.header, @required this.list, this.state});

  _navigateAndDisplaySelection(BuildContext context, RecipeMenuState state, Recipe recipe) async {
    final result = await Navigator.of(context).pushNamed(
      '/view-recipe',
      arguments: recipe,
    );
    if (result != null && state != null) if (result) state.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(header: header),
        FutureBuilder<List<Recipe>>(
          future: list,
          builder:
              (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
            return snapshot.hasData
                ? ListView(
                shrinkWrap: true,
                children: snapshot.data
                    .map((recipe) => GestureDetector(
                  child: RecipeTile(recipe, context),
                  onTap: () => _navigateAndDisplaySelection(context, state, recipe),
                ))
                    .toList())
                : SizedBox();
          },
        ),
      ],
    );
  }
}