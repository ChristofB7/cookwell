import 'package:cookwell/widgets/recipe_searchbar.dart';
import 'package:flutter/material.dart';

class SearchRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showSearch(context: context, delegate: RecipeSearchBarState());
  }
}

