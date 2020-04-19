import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../models/ad.dart';
import '../providers/ads.dart';
import '../providers/auth.dart';
import '../providers/toaster.dart';
import '../widgets/app_drawer.dart';
import '../screens/home.dart';

class AdUserList extends StatefulWidget {
  static const routeName = '/ad-user-list';
  @override
  _AdUserListState createState() => _AdUserListState();
}

class _AdUserListState extends State<AdUserList> {
  User _user;
  List<Ad> _userAds;
  bool _isLoading = true;
  bool _hasMessages = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var adsProvider = Provider.of<Ads>(context);
    var authProvider = Provider.of<Auth>(context);
    var toasterProvider = Provider.of<Toaster>(context);
    if (toasterProvider.message) {
      _hasMessages = true;
    }
    if (authProvider.isAuth) {
      _user = authProvider.getUser();
    }
    if (_user != null) {
      _userAds = await adsProvider.fetchItemsFromUser(_user.id);

      _isLoading = false;
    } else {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  void confirmDeletion(BuildContext ctx, String adId) async {
    await showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Verwijderen?'),
        content:
            Text('Weet je zeker dat je deze advertentie wilt verwijderen?'),
        actions: <Widget>[
          RaisedButton(
            color: Theme.of(ctx).accentColor,
            textColor: Theme.of(ctx).primaryColor,
            onPressed: () async {
              var result = await Provider.of<Ads>(ctx).removeAd(adId);
              if (result) {
                Provider.of<Toaster>(context)
                    .setMessage('Je advertentie is verwijderd.');
              } else {
                Provider.of<Toaster>(context)
                    .setMessage('Je advertentie kon niet worden verwijderd.');
              }
              Navigator.of(ctx).pop();
            },
            child: Text('Ja, verwijder deze advertentie'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Je advertenties'),
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.add_circle_outline),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName,
                  arguments: {'idx': 4});
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userAds.length == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Je hebt nog geen advertenties aangemaakt.',
                        style: Theme.of(context).textTheme.body2,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              HomeScreen.routeName,
                              arguments: {'idx': 4});
                        },
                        color: Theme.of(context).accentColor,
                        child: Text('Maak een nieuwe advertentie'),
                      )
                    ],
                  ),
                )
              : Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        Provider.of<Toaster>(context).showSnackBar(context));
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: _userAds.length,
                          itemBuilder: (context, idx) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).cardColor),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _userAds[idx].title,
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                          color: Theme.of(context).primaryColor,
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text('TO DO'),
                                                      content: Text(
                                                          'Je kunt advertenties op dit moment nog niet wijzigen. Hier wordt aan gewerkt. Op dit moment is je enige optie om de advertentie te verwijderen, en daarna een nieuwe aan te maken. Excuus voor de overlast.'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        )
                                                      ],
                                                    ));
                                          }),
                                      IconButton(
                                        icon: Icon(Icons.delete_forever),
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          confirmDeletion(
                                              context, _userAds[idx].id);
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                    );
                  },
                ),
    );
  }
}
