import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_it/utils/theme_prefences.dart';

class MyTheme with ChangeNotifier {
  bool _isDark = false;
  ThemePreferences _preferences = ThemePreferences();
  bool get isDark => _isDark;

  MyTheme() {
    _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }

  static ThemeData lightTheme(BuildContext context) => ThemeData(
        secondaryHeaderColor: darkBluishColor,
        primarySwatch: Colors.indigo,
        fontFamily: GoogleFonts.poppins().fontFamily,
        cardColor: Colors.white,
        canvasColor: Colors.indigo[100],
        buttonTheme: ButtonThemeData(
          buttonColor: darkBluishColor,
        ),
        focusColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 25,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), side: BorderSide.none),
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        secondaryHeaderColor: ligthBluishColor,
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        focusColor: Colors.transparent,
        fontFamily: GoogleFonts.poppins().fontFamily,
        cardColor: Colors.black,
        canvasColor: Colors.grey[900],
        buttonTheme: ButtonThemeData(
          buttonColor: darkBluishColor,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blue,
          elevation: 0,
          centerTitle: true,
          toolbarTextStyle: const TextStyle(color: Colors.white),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 25,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.blueGrey[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), side: BorderSide.none),
        ),
      );

  // Colors
  static Color creamColor = const Color(0xfff5f5f5);
  static Color darkBluishColor = const Color(0xff403b58);
  static Color ligthBluishColor = Colors.indigoAccent;
  static List<BoxShadow> neumorpShadow = [
    BoxShadow(
        color: Colors.white.withOpacity(0.5),
        spreadRadius: -5,
        offset: const Offset(-5, -5),
        blurRadius: 30),
    BoxShadow(
        color: Colors.blue[900]!.withOpacity(.2),
        spreadRadius: 2,
        offset: const Offset(7, 7),
        blurRadius: 20)
  ];
  static Color gradientColor1 = const Color(0xFF3764B8);
  static Color gradientColor2 = const Color(0xFF47D3E7);
}
