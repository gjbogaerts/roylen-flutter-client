import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//screens
import './screens/ads_list.dart';

//providers
import './providers/ads.dart';

void main() => runApp(Roylen());

class Roylen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Ads()),
      ],
      child: MaterialApp(
        title: 'Roylen',
        theme: ThemeData(
          primaryColor: Color(0xff053505),
          accentColor: Color(0xffe9a401),
          canvasColor: Color(0xfffefaee),
          cardColor: Color(0xffefefef),
          errorColor: Color(0xffee3333),
          primaryTextTheme: TextTheme(
            title: TextStyle(fontSize: 28.0, fontFamily: 'QuickSand'),
          ),
          textTheme: TextTheme(
            title: TextStyle(fontSize: 36.0, fontFamily: 'Quicksand'),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Dosis'),
          ),
        ),
        home: AdsList(),
        routes: {},
        initialRoute: '/',
      ),
    );
  }
}
