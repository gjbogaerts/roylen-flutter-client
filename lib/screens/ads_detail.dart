import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/server_interface.dart';
import '../providers/ads.dart';

class AdsDetail extends StatelessWidget {
  final baseUrl = ServerInterface.getBaseUrl();
  static const routeName = '/ads-detail';
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
                print('favoriting');
              })
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
              child: Image.network(
            '$baseUrl${ad.picture}',
            fit: BoxFit.cover,
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
