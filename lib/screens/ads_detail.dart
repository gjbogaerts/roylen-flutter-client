import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/server_interface.dart';
import '../models/user.dart';
import '../providers/ads.dart';
import '../providers/auth.dart';
import '../widgets/contact.dart';
import '../widgets/offer.dart';
import '../widgets/background.dart';
import './ads_categoried_list.dart';

class ScreenArguments {
  final String categoryType;
  final String category;
  ScreenArguments(this.categoryType, this.category);
}

class AdsDetail extends StatefulWidget {
  static const routeName = '/ads-detail';

  @override
  _AdsDetailState createState() => _AdsDetailState();
}

class _AdsDetailState extends State<AdsDetail> {
  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Provider.of<Auth>(context).isAuth) {
      _user = Provider.of<Auth>(context).getUser();
    }
  }

  void _showDialog(String msg, {String title = 'Dank je wel!'}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(
          msg,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            textColor: Theme.of(context).canvasColor,
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _contactCreator(ad) {
    if (_user != null) {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (context) => Contact(_user, ad),
        isScrollControlled: true,
      );
    } else {
      _showDialog(
          'Je moet ingelogd zijn om een boodschap aan deze adverteerder te kunnen sturen.',
          title: 'Graag inloggen');
    }
  }

  void _makeOffer(ad) {
    if (_user != null) {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        context: context,
        builder: (context) => Offer(_user, ad),
        isScrollControlled: true,
      );
    } else {
      _showDialog('Je moet ingelogd zijn om een bod te kunnen uitbrengen.',
          title: 'Graag inloggen');
    }
  }

  void _setFavorite(String id) async {
    String msg;
    var result = await Provider.of<Ads>(context, listen: false).setFavorite(id);
    if (result) {
      msg = 'Deze advertentie wordt bewaard in je favorietenlijstje.';
    } else {
      msg =
          'Er ging iets mis tijdens de opslag in je favorietenlijstje. Probeer het alsjeblieft later nog een keer.';
    }
    _showDialog(msg);
  }

  void _warnAdmin(String id) async {
    String msg;
    var result = await Provider.of<Ads>(context, listen: false).warnAboutAd(id);
    if (result) {
      msg =
          'Je waarschuwing is doorgegeven. Dank voor je betrokkenheid. De beheerders van Roylen gaan kijken wat er mis is met deze advertentie en eventueel actie ondernemen.';
    } else {
      msg =
          'Excuus, er is iets misgegaan. Probeer het later nog eens alsjeblieft?';
    }
    _showDialog(msg);
  }

  final baseUrl = ServerInterface.getBaseUrl();

  @override
  Widget build(BuildContext context) {
    final ad = Provider.of<Ads>(context)
        .getById(ModalRoute.of(context).settings.arguments);
    final _dateAdded = DateFormat.yMEd()
        .addPattern('H:m')
        .format(DateTime.parse(ad.dateAdded));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ad.title,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                _setFavorite(ad.id);
              }),
          IconButton(
              icon: Icon(Icons.warning),
              color: Theme.of(context).errorColor,
              onPressed: () {
                _warnAdmin(ad.id);
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Background(),
          ListView(
            children: <Widget>[
              Container(
                child: Image.network(
                  '$baseUrl${ad.picture}',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${ad.virtualPrice} nix',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AdsCategoriedList.routeName, arguments: {
                          'categoryType': 'mainCategory',
                          'category': ad.mainCategory
                        });
                        // print('${ad.mainCategory} pressed');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(),
                          ),
                        ),
                        child: Text('${ad.mainCategory}'),
                      ),
                    ),
                    if (ad.subCategory.isNotEmpty)
                      Row(
                        children: <Widget>[
                          Text(' > '),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AdsCategoriedList.routeName,
                                  arguments: {
                                    'categoryType': 'subCategory',
                                    'category': ad.subCategory
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(),
                                ),
                              ),
                              child: Text('${ad.subCategory}'),
                            ),
                          ),
                        ],
                      ),
                    if (ad.subSubCategory.isNotEmpty)
                      Row(
                        children: <Widget>[
                          Text(' > '),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AdsCategoriedList.routeName,
                                  arguments: {
                                    'categoryType': 'subSubCategory',
                                    'category': ad.subSubCategory
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(),
                                ),
                              ),
                              child: Text('${ad.subSubCategory}'),
                            ),
                          ),
                        ],
                      ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ),
              if (ad.ageCategory.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Text('Leeftijd: '),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              AdsCategoriedList.routeName,
                              arguments: {
                                'categoryType': 'ageCategory',
                                'category': ad.ageCategory
                              });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(),
                            ),
                          ),
                          child: Text('${ad.ageCategory}'),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 10),
              Container(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('$baseUrl${ad.creator.avatar}'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Aangemaakt door: ${ad.creator.screenName} \nop $_dateAdded',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${ad.description}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      _contactCreator(ad);
                    },
                    child: Text('CONTACT'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _makeOffer(ad);
                    },
                    child: Text('BIED NIX'),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
