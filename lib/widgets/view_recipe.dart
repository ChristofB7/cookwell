import 'package:cookwell/model/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewRecipe extends StatelessWidget {
  Recipe recipe;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    //get the recipe from the settings sent from the OnTap
    recipe = ModalRoute.of(context).settings.arguments as Recipe;

    return Scaffold(
      backgroundColor: colorScheme.background,
      //Single Child Scroll View to allow user to scroll through the page
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    height: 210.0,
                    //IMAGE
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: recipe.image.image, fit: BoxFit.cover)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //BACK ICON
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                    ),

                    //FAVORITES GO HERE
                    IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {},
                      color: Colors.white,
                    )
                  ],
                )
              ],
            ),

            //Container with Serving Size, Prep Time, and Cooking Time
            //Spaced using a Flex, and Flexible children
            //Could probably be optimized?
            Card(
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 1,
                      child: (recipe.servingSize == 1)
                          ? Icon(Icons.person_outline)
                          : Icon(Icons.people_outline)),
                  Flexible(
                    flex: 2,
                    child: (recipe.servingSize == 1)
                        ? Text(
                            'Serving Size: ${recipe.servingSize.toStringAsFixed(0)} Person')
                        : Text(
                            'Serving Size: ${recipe.servingSize.toStringAsFixed(0)} People'),
                  ),
                  Flexible(flex: 1, child: Icon(Icons.av_timer)),
                  Flexible(
                    flex: 2,
                    child:
                        Text('Prep Time: ${recipe.prepTime.inMinutes} minutes'),
                  ),
                  Flexible(flex: 1, child: Icon(Icons.access_time)),
                  Flexible(
                    flex: 2,
                    child: Text(
                        'Cook Time: ${recipe.cookingTime.inMinutes} minutes'),
                  ),
                ],
              ),
            ),

            Divider(
              thickness: 3,
              indent: 20,
              endIndent: 20,
            ),

            //ListView containing both ingreidnets and directions
            ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                //Ingredients text followed by a column of ingredients
                Text(
                  "Ingredients",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.ingredients
                      .map((ingredient) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              ingredient.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                              ),
                            ),
                          ))
                      .toList(),
                ),

                //Directions Text followed by
                Text(
                  "Directions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.directions
                      .asMap()
                      .entries
                      .map((direction) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '${direction.key + 1}. ${direction.value}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
