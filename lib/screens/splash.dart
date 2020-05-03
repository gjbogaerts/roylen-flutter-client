import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image9.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text('Welkom bij Roylen',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'QuickSand')),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'De ruil-app voor jonge ouders, hun kinderen en de planeet',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
            ],
          )
        ],
      ),

      /* Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/image9.jpeg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[],
        ),
      ), */
    );
  }
}
