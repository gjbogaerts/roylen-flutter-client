import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/server_interface.dart';
import '../providers/ads.dart';

class AdsDetail extends StatefulWidget {
  static const routeName = '/ads-detail';

  @override
  _AdsDetailState createState() => _AdsDetailState();
}

class _AdsDetailState extends State<AdsDetail> {
  void _showDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Dank je wel!',
        ),
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
      body: ListView(
        children: <Widget>[
          Container(
              child: Image.network(
            '$baseUrl${ad.picture}',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height / 3,
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${ad.virtualPrice} nix',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      print('Interested');
                    },
                    color: Theme.of(context).accentColor,
                    child: Text('CONTACT'),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  ad.category,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage('$baseUrl${ad.creator.avatar}'),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Aangemaakt door: ${ad.creator.screenName}',
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
              'Beschrijving: ${ad.description}',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
