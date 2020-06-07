import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/server_interface.dart';
import '../models/user.dart';
import '../models/ad.dart';
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
  bool _isFavorite = false;

  String _mainImage;
  Ad _ad;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ad = Provider.of<Ads>(context)
        .getById(ModalRoute.of(context).settings.arguments);
    _mainImage = _ad.picture;
    if (Provider.of<Auth>(context).isAuth) {
      _user = Provider.of<Auth>(context).getUser();
      if (_user.favoriteAds != null) {
        _isFavorite = _user.favoriteAds.any((element) => element == _ad.id);
      }
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
    if (_user == null) {
      _showDialog(
          'Je moet ingelogd zijn om een advertentie in je favorietenlijstje te kunnen bewaren.',
          title: 'Graag inloggen!');
      return;
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
    Provider.of<Auth>(context, listen: false).updateFavorite(id);
    await Provider.of<Ads>(context, listen: false).setFavorite(id);
  }

  void _warnAdmin(String id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Stuur waarschuwing'),
          content: Text(
            'Als je op OK klikt, wordt er een waarschuwing over deze advertentie doorgegeven aan de beheerders. Zij gaan dan kijken wat er mis is met deze advertentie en eventueel actie ondernemen.',
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Laat maar zitten'),
              textColor: Theme.of(context).accentColor,
              onPressed: () => Navigator.of(context).pop(),
            ),
            RaisedButton(
              child: Text('OK'),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                await Provider.of<Ads>(context, listen: false).warnAboutAd(id);
                Navigator.of(context).pop();
                _showDialog(
                    'Je waarschuwing is doorgegeven. Dank voor je betrokkenheid.');
              },
            )
          ],
        );
      },
    );
  }

  Widget _showImageArray(List imgs) {
    return Column(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          children: List.generate(imgs.length, (index) {
            var _img = imgs[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _mainImage = _img;
                });
              },
              child: Image.network(
                '$baseUrl$_img',
                fit: BoxFit.contain,
              ),
            );
          }),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  final baseUrl = ServerInterface.getBaseUrl();

  @override
  Widget build(BuildContext context) {
    final _dateAdded = DateFormat.yMEd()
        .addPattern('H:m')
        .format(DateTime.parse(_ad.dateAdded));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _ad.title,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                _setFavorite(_ad.id);
              }),
          IconButton(
              icon: Icon(Icons.warning),
              onPressed: () {
                _warnAdmin(_ad.id);
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
                  '$baseUrl$_mainImage',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ),
              SizedBox(height: 10),
              if (_ad.pictureArray.length > 1)
                _showImageArray(_ad.pictureArray),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${_ad.virtualPrice} nix',
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
                          'category': _ad.mainCategory
                        });
                        // print('${ad.mainCategory} pressed');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(),
                          ),
                        ),
                        child: Text('${_ad.mainCategory}'),
                      ),
                    ),
                    if (_ad.subCategory.isNotEmpty)
                      Row(
                        children: <Widget>[
                          Text(' > '),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AdsCategoriedList.routeName,
                                  arguments: {
                                    'categoryType': 'subCategory',
                                    'category': _ad.subCategory
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(),
                                ),
                              ),
                              child: Text('${_ad.subCategory}'),
                            ),
                          ),
                        ],
                      ),
                    if (_ad.subSubCategory.isNotEmpty)
                      Row(
                        children: <Widget>[
                          Text(' > '),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AdsCategoriedList.routeName,
                                  arguments: {
                                    'categoryType': 'subSubCategory',
                                    'category': _ad.subSubCategory
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(),
                                ),
                              ),
                              child: Text('${_ad.subSubCategory}'),
                            ),
                          ),
                        ],
                      ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ),
              if (_ad.ageCategory.isNotEmpty)
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
                                'category': _ad.ageCategory
                              });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(),
                            ),
                          ),
                          child: Text('${_ad.ageCategory}'),
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
                          NetworkImage('$baseUrl${_ad.creator.avatar}'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Aangemaakt door: ${_ad.creator.screenName} \nop $_dateAdded',
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
                  '${_ad.description}',
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
                      _contactCreator(_ad);
                    },
                    child: Text('CONTACT'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _makeOffer(_ad);
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
