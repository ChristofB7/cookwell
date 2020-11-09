import 'package:cookwell/widgets/cookbook_menu.dart';
import 'package:cookwell/widgets/shopping_menu.dart';
import 'package:cookwell/widgets/view_recipe.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildColorTheme(),
      title: 'CookWell',
      home: MyHomePage(),
      routes: {
        '/view-recipe' : (context) => ViewRecipe()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _pages;
  Widget _groceryMenu;
  Widget _shoppingMenu;

  int _currentIndex;
  Widget _currentPage;

  @override
  void initState() {
    super.initState();

    _groceryMenu = RecipeMenu();
    _shoppingMenu = ShoppingMenu();

    _pages = [_groceryMenu, _shoppingMenu];

    _currentIndex = 0;
    _currentPage = _groceryMenu;
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookwell'),
        backgroundColor: ColorTheme.primary,
      ),
      drawer: new Drawer(
        child: new Container(
          margin: EdgeInsets.only(top: 20.0),
          child: new Column(
            children: <Widget>[
              navigationItemListTitle("Recipes", 0),
              navigationItemListTitle("Shopping", 1),
            ],
          ),
        ),
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.onSurface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (index) => changeTab(index),
        items: [
          BottomNavigationBarItem(
             // make constant
            label: 'My Cookbook',
            icon: Icon(Icons.fastfood_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Shopping',
            icon: Icon(Icons.list),
          ),
        ],
      ),
    );
  }

  Widget navigationItemListTitle(String title, int index) {
    return new ListTile(
      title: new Text(
        title,
        style: new TextStyle(color: Theme.of(context).colorScheme.secondaryVariant, fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        changeTab(index);
      },
    );
  }
}

//TODO
ThemeData _buildColorTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: ColorTheme,
    textTheme: _buildTextTheme(base.textTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        button: base.button.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: charcoal,
        bodyColor: charcoal,
      );
}

const ColorScheme ColorTheme = ColorScheme(
  primary: charcoal,
  primaryVariant: queenBlue,
  secondary: englishLavender,
  secondaryVariant: queenPink,
  surface: surfaceColor,
  background: darkSkyBlue,
  error: errorRed,
  onPrimary: englishLavender,
  onSecondary: englishLavender,
  onSurface: englishLavender,
  onBackground: englishLavender,
  onError: surfaceColor,
  brightness: Brightness.light,
);

const Color darkSkyBlue = Color(0xFF8CB1B9);
const Color queenBlue = Color(0xFF33658A);
const Color charcoal = Color(0xFF2F4858);
const Color queenPink = Color(0xFFE2C2C6);
const Color englishLavender = Color(0xFFB9929F);

const Color errorRed = Color(0xFFC5032B);

const Color surfaceColor = Color(0xFFF9F8FE);
const Color backgroundWhite = Colors.white;

const defaultLetterSpacing = 0.02;
