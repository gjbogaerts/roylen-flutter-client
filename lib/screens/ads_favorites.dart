import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../providers/auth.dart';
import '../models/user.dart';
import '../models/ad.dart';
import '../widgets/ads_grid.dart';
import '../widgets/background.dart';
import '../widgets/my_dialog.dart';
import './auth.dart' as LoginScreen;

class AdsFavorites extends StatefulWidget {
  static const routeName = '/ads-favorites';

  @override
  _AdsFavoritesState createState() => _AdsFavoritesState();
}

class _AdsFavoritesState extends State<AdsFavorites> {
  List<Ad> adsData;
  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var authProvider = Provider.of<Auth>(context);

    setState(() {
      if (authProvider.isAuth) {
        _user = authProvider.getUser();
      }
    });
  }

  void navigateToAuth() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            settings: RouteSettings(arguments: {'registering': false}),
            builder: (BuildContext context) => LoginScreen.Auth()));
  }

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? MyDialog(navigateToAuth, 'Log in',
            'Je moet ingelogd zijn om je favorieten te kunnen zien', 'Log in')
        : Stack(
            children: <Widget>[
              Background(),
              FutureBuilder(
                future: Provider.of<Ads>(context).fetchAndSetFavoriteItems(),
                builder: (context, result) {
                  return result.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : AdsGrid(result.data);
                },
              )
            ],
          );
  }
}
