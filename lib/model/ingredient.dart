import 'package:cookwell/model/unit.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

class Ingredient {
  String name;
  Unit unit;
  double amount;
  bool optional;

  Ingredient({@required this.name, this.unit, this.amount});

  Map<String, dynamic> toMap() =>{
    "name": name,
    "unit" : unit.toUnitString(),
    "amount": amount,
    "optional": optional ? 1 : 0
  };

  Ingredient.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    unit = EnumToString.fromString(Unit.values, map['unit']);
    amount = map['amount'].toDouble();
    optional = map['optional'] == 1;
  }

  static Ingredient parseIngredient(String input) {
    List inputs = input.split(' ');

    double amount = num.tryParse(inputs[0]) != null ? num.tryParse(inputs[0]).toDouble() : 0;
    Unit unit = EnumToString.fromString(Unit.values, inputs[1]);
    //TODO
    String name = inputs.sublist(2).join(' ').trim();

    return Ingredient(name: name, unit: unit, amount: amount);
  }
}
