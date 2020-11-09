import 'package:cookwell/model/dummy_data.dart';
import 'package:cookwell/widgets/view_recipe.dart';
import 'package:flutter/material.dart';

class RecipeMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: dummy_recipes
            .map((recipe) => GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/view-recipe', arguments: recipe,
            );},
              child: SizedBox(
                    height: 120,
                    width: 100,
                    child: Column(
                      children: [
                        recipe.image,
                        Text(recipe.name),
                      ],
                    ),
                  ),
            ))
            .toList(),
      ),
    );
  }
}
