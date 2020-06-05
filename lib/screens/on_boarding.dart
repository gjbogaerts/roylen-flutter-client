import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import '../widgets/background.dart';
import './home.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _slideIndex = 0;
  final List<String> images = [
    'assets/images/LogoGroen.png',
    'assets/images/image2.png',
    'assets/images/image5.png',
    'assets/images/image6.png',
  ];
  final List<String> titles = [
    'Laten we beginnen',
    'Wat kan ik ermee?',
    'Hoe doe ik dat?',
    'En nu?'
  ];
  final List<String> text = [
    'Wat fijn dat je Roylen hebt geïnstalleerd! In vier schermen krijg je een korte uitleg wat je met Roylen kunt doen.',
    'Met deze app bespaar je geld en help je het milieu. Je hoeft niet meer elke drie maanden nieuwe kleren voor je kinderen te kopen, of het speelgoed weg te gooien waarop ze uitgekeken zijn. In plaats daarvan ruil je deze spullen met andere (jonge) ouders.',
    'Je maakt een account aan, maakt een foto van wat je te ruilen wilt aanbieden, geeft nog wat details, en laat dan de reacties maar komen! Als je iets moois aanbiedt, kun je \'nix\' krijgen, de interne munteenheid van Roylen. Met die nix kun je later weer andere spullen ruilen.',
    'En nu heb je de belangrijkste info, en kun je aan de gang. Je kunt eerst een beetje rondkijken, of meteen een account maken en een advertentie plaatsen.',
  ];

  final controller = IndexController();

  @override
  Widget build(BuildContext context) {
    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            this._slideIndex = index;
          });
        },
        loop: false,
        controller: controller,
        transformer:
            PageTransformerBuilder(builder: (Widget child, TransformInfo info) {
          return Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ParallaxContainer(
                        child: Text(
                          titles[info.index],
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 24.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                        position: info.position,
                        opacityFactor: .8,
                        translationFactor: 400.0,
                      ),
                      ParallaxContainer(
                        child: Image.asset(
                          images[info.index],
                          fit: BoxFit.contain,
                          height: 350,
                        ),
                        position: info.position,
                        translationFactor: 400.0,
                      ),
                      ParallaxContainer(
                        child: Text(
                          text[info.index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                        position: info.position,
                        translationFactor: 300.0,
                      ),
                      ParallaxContainer(
                        position: info.position,
                        translationFactor: 500.0,
                        child: Dots(
                          controller: controller,
                          slideIndex: _slideIndex,
                          numberOfDots: images.length,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        itemCount: 4);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welkom bij Roylen!'),
      ),
      body: Stack(
        children: <Widget>[
          Background(),
          transformerPageView,
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              foregroundColor: Theme.of(context).accentColor,
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName);
              },
              child: Text(_slideIndex == 3 ? 'Start' : 'Skip'),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class Dots extends StatelessWidget {
  final IndexController controller;
  final int slideIndex;
  final int numberOfDots;

  Dots({this.controller, this.slideIndex, this.numberOfDots});

  Widget _activeSlide(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Tapped');
        // controller.move(index);
      },
      child: new Container(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inactiveSlide(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.move(index);
      },
      child: new Container(
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Container(
            width: 14.0,
            height: 14.0,
            decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  List<Widget> _generateDots(context) {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == slideIndex
          ? _activeSlide(i, context)
          : _inactiveSlide(i, context));
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _generateDots(context),
    ));
  }
}
