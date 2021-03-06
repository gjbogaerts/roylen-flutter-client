import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import './ads_categoried_list.dart';
import '../models/ad.dart';
import '../models/user.dart';
import '../providers/ads.dart';
import '../providers/auth.dart';
import '../utils/api_key.dart';
import '../utils/server_interface.dart';
import '../widgets/background.dart';
import '../widgets/contact.dart';
import '../widgets/offer.dart';

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
  final baseUrl = ServerInterface.getBaseUrl();
  String _mainImage;
  Uri _detailPageDeepLink;
  Ad _ad;

  void initBuildDynamicLink(String adId) async {
    final DynamicLinkParameters _params = DynamicLinkParameters(
      link: Uri.parse('https://roylen.net/detail/$adId'),
      uriPrefix: ApiKey.getDeepLink(),
      androidParameters: AndroidParameters(
        packageName: 'nl.raker.roylen',
      ),
      iosParameters: IosParameters(
        appStoreId: '1512764806',
        bundleId: 'nl.raker.roylen',
      ),
    );
    _detailPageDeepLink = await _params.buildUrl();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ad = Provider.of<Ads>(context)
        .getById(ModalRoute.of(context).settings.arguments);
    _mainImage = _ad.picture;
    initBuildDynamicLink(_ad.id);
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
              child: Image.network('$baseUrl$_img', fit: BoxFit.cover),
            );
          }),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _ios = Theme.of(context).platform == TargetPlatform.iOS;
    final _dateFormat = DateFormat('dd-MM-yyyy, HH:mm');
    final _dateAdded = _dateFormat.format(DateTime.parse(_ad.dateAdded));
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: <Widget>[
          IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                _setFavorite(_ad.id);
              }),
          Builder(
            builder: (BuildContext ctx) => IconButton(
              icon: Icon(_ios ? CupertinoIcons.share : Icons.share),
              onPressed: () {
                final String _scheme = '$_detailPageDeepLink';
                final RenderBox box = ctx.findRenderObject();
                Share.share(_scheme,
                    subject: 'Advertentie van Roylen app',
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
            ),
          ),
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
                alignment: Alignment.center,
                child: Text(
                  _ad.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${_ad.virtualPrice} nix',
                  style: TextStyle(fontSize: 20),
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
                    if (_ad.subCategory.isNotEmpty && _ad.subCategory != "null")
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
                    if (_ad.subSubCategory.isNotEmpty &&
                        _ad.subSubCategory != "null")
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
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${_ad.description}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                  softWrap: true,
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(
                height: 20,
              ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AdsCategoriedList.routeName, arguments: {
                          'categoryType': 'creator',
                          'category': _ad.creator.id
                        });
                      },
                      child: Container(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText2,
                            children: [
                              TextSpan(
                                text: 'Aangemaakt door: ',
                              ),
                              TextSpan(
                                text: '${_ad.creator.screenName}',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2),
                              ),
                              TextSpan(text: ' \nop $_dateAdded')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
