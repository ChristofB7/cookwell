import 'package:cookwell/model/unit.dart';
import 'package:flutter/foundation.dart';

class Ingredient {
  String name;
  //look to switch to enum
  Unit unit;
  double amount;

  Ingredient({@required this.name, this.unit, @required this.amount});

  String toString() {
    return '${amount % 1 == 0 ? amount.toStringAsFixed(0) : amount.toStringAsFixed(1)} ${unit == null ? '' : unit.toString().substring(unit.toString().indexOf('.') + 1)} $name';
  }
}
