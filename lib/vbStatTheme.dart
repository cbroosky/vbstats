import 'package:flutter/material.dart';

// import 'colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    //1
    return ThemeData(
        //2
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat', //3
        buttonTheme: ButtonThemeData(
          // 4
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purpleAccent,
        ));
  }

  static ThemeData get darkTheme {
    //1
    return ThemeData(
        //2
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.blueGrey,
          contentTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),

          ),
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xff1e1f26),
        cardColor: const Color.fromARGB(150, 173, 32, 32),
        colorScheme: const ColorScheme(
            primary: Colors.red,
            background: Color(0xff1e1f26),
            brightness: Brightness.dark,
            error: Color(0xffff1414),
            onBackground: Color.fromARGB(150, 173, 32, 32),
            onError: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            secondary: Color.fromARGB(179, 207, 18, 18),
            surface: Color.fromARGB(179, 207, 18, 18)),
        fontFamily: 'Montserrat', //3
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purpleAccent,
        ));

        
  }
}
