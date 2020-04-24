import 'package:flutter/material.dart';

class RoylenTheme {
  static ThemeData getThemeData() {
    return ThemeData(
      dialogTheme: DialogTheme(
          backgroundColor: Color(0xff053505),
          contentTextStyle: TextStyle(
              color: Color(0xfffefaee), fontFamily: 'Dosis', fontSize: 14.0),
          titleTextStyle: TextStyle(
              color: Color(0xfffefaee),
              fontFamily: 'QuickSand',
              fontSize: 28.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      primaryColor: Color(0xff053505),
      accentColor: Color(0xffe9a401),
      canvasColor: Color(0xfffefaee),
      cardColor: Color(0xffefefef),
      errorColor: Color(0xffee3333),
      buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textTheme: ButtonTextTheme.normal,
          minWidth: 100,
          height: 36),
      primaryTextTheme: TextTheme(
        title: TextStyle(
            fontSize: 28.0, fontFamily: 'QuickSand', color: Color(0xfffefaee)),
      ),
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 36.0,
          fontFamily: 'Quicksand',
          color: Color(0xff053505),
        ),
        body1: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Dosis',
          color: Color(0xff053505),
        ),
        body2: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Dosis',
          fontWeight: FontWeight.bold,
          color: Color(0xff053505),
        ),
      ),
    );
  }
}
