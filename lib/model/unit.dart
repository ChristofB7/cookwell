enum Unit {
  cup,
  ounce,
  fluidounce,
  teaspoon,
  tablespoon,
  quart,
  pint,
  gallon,
  pound,
  milliliter,
  gram,
  kilogram,
  liter
}

extension ParseToString on Unit {
  String toUnitString() {
    return this.toString().split('.').last;
  }
}