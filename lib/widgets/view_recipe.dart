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
            // a stack allows us to put the back iconbutton and the favorite icon button ontop of the image
            Stack(
              children: <Widget>[
                //the card to make the border of the image
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    height: 210.0,
                    //This is just an image
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: recipe.image.image, fit: BoxFit.cover)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //BACK ICON button
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        // the context is the previous screen
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

            //Card with Serving Size, Prep Time, and Cooking Time
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
            Text(
              "Ingredients",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients
                  //Row of Image, ingredient.toString, and iconbutton
                  .map((ingredient) => Row(
                        children: [
                          //Image - this will be the image of the ingreidents
                          Image(
                              height: 40, width: 30, image: recipe.image.image),
                          //Expanded to take up as much space as possible
                          Expanded(
                            child: Row(
                              children: [
                                ingredient.amount % 1 == 0
                                    //if ingredient is a whole number make an int
                                    ? Text(
                                        '${ingredient.amount.toStringAsFixed(0)} ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    //otherwise make a double
                                    : Text('${ingredient.amount.toString()} ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),

                                //if the ignredient amount is equal to or less than 1
                                ingredient.amount <= 1
                                    ? Text(
                                        //if the ingredient unit exists then just add a space after
                                        '${ingredient.unit == null ? '' : ingredient.unit.toString().split('.').last + ' '}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                    //otherwise add an 'S' at the end for cups (if the unit exists)
                                    : Text(
                                        '${ingredient.unit == null ? '' : ingredient.unit.toString().split('.').last + 's '}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                Text(
                                  ingredient.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryVariant,
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
                                icon: Icon(Icons.local_grocery_store),
                                onPressed: () {}),
                          )
                        ],
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
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
