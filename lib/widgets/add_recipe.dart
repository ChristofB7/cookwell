import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

//TODO tolowercase when saving in db
//TODO save search queries to db

class _AddRecipeState extends State<AddRecipe> {

  final recipesDatabase = FirebaseFirestore.instance.collection("recipes");

  Future<void> addRecipe() {
    // Call the user's CollectionReference to add a new user
    return recipesDatabase
        .add({
      /*'name':
      'ingredients':
      'directions': // */
    })
        //TODO snackbar
        .then((value) => print("Recipe Added"))
        .catchError((error) => print("Failed to add recipe: $error"));
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container());
  }
}