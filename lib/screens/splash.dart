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
                image: AssetImage('assets/images/bgimage.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text('Welkom bij Roylen',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PatrickHandSC')),
              ),
              Center(
                child: Image(
                  image: AssetImage('assets/images/LogoGroen.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: Text(
                    'De ruil-app voor jonge ouders, hun kinderen en de planeet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontSize: 24, fontFamily: 'QuickSand'),
                  ),
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
