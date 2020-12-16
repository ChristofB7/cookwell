import 'package:cookwell/model/unit.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

// TODO optional boolean
class Ingredient {
  String name;
  //look to switch to enum
  Unit unit;
  double amount;

  Ingredient({@required this.name, this.unit, @required this.amount});

  Map<String, dynamic> toMap() =>{
    "name": name,
    "unit" : unit.toUnitString(),
    "amount": amount,
  };

  Ingredient.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    unit = EnumToString.fromString(Unit.values, map['unit']);
    amount = map['amount'];
  }

  String toString() {
    return '${amount % 1 == 0 ? amount.toStringAsFixed(0) : amount.toStringAsFixed(1)} ${unit == null ? '' : unit.toString().substring(unit.toString().indexOf('.') + 1)} $name';
  }
}
