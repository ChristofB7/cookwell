import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:flutter/material.dart';

import 'components/vertical_recipes_list.dart';

class MyCookbook extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future<List<Recipe>> localRecipes = DatabaseProvider.getRecipes();

    return Column(children: [
      VerticalRecipesList(header: "MYCOOKBOOK", list: localRecipes)
    ],);
  }
}
