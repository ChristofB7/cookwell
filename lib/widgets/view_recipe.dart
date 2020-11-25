import 'package:cookwell/db/shopping_db_provider.dart';
import 'package:cookwell/model/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookwell/model/shopping_item.dart';

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Container(),
            pinned: false,
            expandedHeight: 210,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
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
                  ),
                  Positioned(
                      child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Card(
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
                            child: Text(
                                'Prep Time: ${recipe.prepTime.inMinutes} minutes'),
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
                  ))
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // a stack allows us to put the back iconbutton and the favorite icon button ontop of the image

                //Card with Serving Size, Prep Time, and Cooking Time
                //Spaced using a Flex, and Flexible children
                //Could probably be optimized?
                //<div>Icons made by <a href="https://www.flaticon.com/authors/eucalyp" title="Eucalyp">Eucalyp</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
                Divider(
                  thickness: 3,
                  indent: 20,
                  endIndent: 20,
                ),

                //ListView containing both ingreidnets and directions
                Text(
                  "Ingredients",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.ingredients
                      //Row of Image, ingredient.toString, and iconbutton
                      .map((ingredient) => Row(
                            children: [
                              //Image - this will be the image of the ingreidents
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                // Icon made by https://www.flaticon.com/authors/eucalyp Eucalyp.
                                child: ImageIcon(
                                  AssetImage(
                                      'lib/assets/images/vegetarian.png'),
                                  size: 30,
                                ),
                              ),
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
                                        : Text(
                                            '${ingredient.amount.toString()} ',
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
                                    onPressed: () {
                                      ShoppingDatabaseProvider.addShoppingItem(new ShoppingItem(item: ingredient.name, quantity: 0, checked: false));
                                      final snackBar = SnackBar(content: Text('Added ${ingredient.name} to Shopping List'), duration: const Duration(seconds: 1));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    },),
                              )
                            ],
                          ))
                      .toList(),
                ),

                //Directions Text followed by
                Text(
                  "Directions",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
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
                                fontFamily: 'Vice City',
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
          ]))
        ],
      ),
    );
  }
}
