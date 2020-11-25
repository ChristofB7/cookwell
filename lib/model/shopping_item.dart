import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:share/share.dart';

class ShoppingItem {
  String name;
  int quantity;
  String checked;

  ShoppingItem({@required this.name,
    @required this.quantity,
    @required this.checked,
  });
}
