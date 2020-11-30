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
// Convert to enum
// Fruit f = Fruit.values.firstWhere((e) => e.toString() == str);

}

extension ParseToString on Unit {
  String toUnitString() {
    return this.toString().split('.').last;
  }
}