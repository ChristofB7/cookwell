import 'package:flutter/material.dart';

import '../../model/recipe.dart';

class RecipeDetailCard extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailCard({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
}
