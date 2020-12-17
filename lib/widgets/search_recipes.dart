import 'package:cookwell/widgets/recipe_searchbar.dart';
import 'package:flutter/material.dart';

class SearchRecipes extends StatelessWidget {
  @override
  // TODO fix back button, & create container maybe?
  Widget build(BuildContext context) {
    showSearch(context: context, delegate: RecipeSearchBarState());
  }
}

