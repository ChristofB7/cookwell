import 'package:cookwell/db/db_provider.dart';
import 'package:cookwell/widgets/add_recipe.dart';
import 'package:cookwell/widgets/mycookbook.dart';
import 'package:cookwell/widgets/recipes_menu.dart';
import 'package:cookwell/widgets/search_recipes.dart';
import 'package:cookwell/widgets/shopping_menu.dart';
import 'package:cookwell/widgets/view_recipe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([DatabaseProvider().initDatabase(), Firebase.initializeApp()]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildColorTheme(),
      title: 'CookWell',
      home: MyHomePage(),
      routes: {
        '/view-recipe': (context) => ViewRecipe(),
        '/add-recipe': (context) => AddRecipe(),
        '/all-recipes': (context) => RecipeMenu(),
        '/search-recipe': (context) => SearchRecipes(),
        '/cookbook-menu': (context) => MyCookbook(),
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
  Widget _recipeMenu;
  Widget _shoppingMenu;

  int _currentIndex;
  Widget _currentPage;

  static const String RECIPES = "Recipes";
  static const String SHOPPING = "Shopping";

  @override
  void initState() {
    super.initState();

    _recipeMenu = RecipeMenu();
    _shoppingMenu = ShoppingMenu();
    _pages = [_recipeMenu, _shoppingMenu];

    _currentIndex = 0;
    _currentPage = _recipeMenu;
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
        drawer: Drawer(
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                navigationItemListTitle(RECIPES, _recipeMenu),
                navigationItemListTitle(SHOPPING, _shoppingMenu),
                navigationItemListTitle("Search", SearchRecipes()),
                navigationItemListTitle("MyCookbook", MyCookbook())
              ],
            ),
          ),
        ),
        body: SafeArea(child: _currentPage),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          backgroundColor: colorScheme.primary,
          selectedItemColor: colorScheme.onPrimary,
          unselectedItemColor: colorScheme.onPrimary.withOpacity(.60),
          selectedLabelStyle: textTheme.caption,
          unselectedLabelStyle: textTheme.caption,
          onTap: (index) => changeTab(index),
          items: [
            BottomNavigationBarItem(
              // make constant
              label: RECIPES,
              icon: Icon(Icons.fastfood_rounded),
            ),
            BottomNavigationBarItem(
              label: SHOPPING,
              icon: Icon(Icons.list),
            ),
          ],
        ),
    );
  }

  Widget navigationItemListTitle(String title, Widget widget) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondaryVariant,
            fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _currentPage = widget;
        });
      },
    );
  }
}

ThemeData _buildColorTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: ColorTheme,
    textTheme: _buildTextTheme(base.textTheme),
    hintColor: ColorTheme.primary,
    iconTheme: IconThemeData(color: ColorTheme.primary),
    accentIconTheme: IconThemeData(color: ColorTheme.primary),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: ColorTheme.primary.withOpacity(0.70)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0x00FFFFFF),),),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0x00FFFFFF),),),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0x00FFFFFF),),),
    ),
    unselectedWidgetColor: ColorTheme.primary,
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
        headline6: base.caption.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: defaultLetterSpacing,
        ),
        bodyText2: base.caption.copyWith(
          fontSize: 12,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Arimo',
        displayColor: prussianBlue,
        bodyColor: prussianBlue,
      );
}

const ColorScheme ColorTheme = ColorScheme(
  primary: prussianBlue,
  primaryVariant: bdazzledBlue,
  secondary: iceburgBlue,
  secondaryVariant: columbiaBlue,
  surface: cultured,
  background: white,
  error: errorRed,
  onPrimary: jasmine,
  onSecondary: bdazzledBlue,
  onSurface: bdazzledBlue,
  onBackground: bdazzledBlue,
  onError: white,
  brightness: Brightness.light,
);

const Color white = Color(0xFFFFFFFF);
const Color columbiaBlue = Color(0xFFCDEDFD);
const Color uraniunBlue = Color(0xFFB6DCFE);
const Color prussianBlue = Color(0xFF0B3954);
const Color bdazzledBlue = Color(0xFF235789);
const Color iceburgBlue = Color(0xFF6DA5D9);
const Color honeyYellow = Color(0xFFFBAF00);
const Color jasmine = Color(0xFFFFDA85);
const Color burntOrange = Color(0xFFF67751);
const Color atomicTangerine = Color(0xFFF39D68);
const Color mangoTango = Color(0xFFF08A4B);

const Color queenBlue = Color(0xFF33658A);
const Color charcoal = Color(0xFF2F4858);
const Color cultured = Color(0xFFF3F3F3);
const Color errorRed = Color(0xFFC5032B);

const defaultLetterSpacing = 0.05;
