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
  bool _isInit = true;
  bool _isLoading = false;
  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var adsProvider = Provider.of<Ads>(context);
    var authProvider = Provider.of<Auth>(context);
    if (_isInit) {
      setState(() {
        _isLoading = true;
        if (authProvider.isAuth) {
          _user = authProvider.getUser();

          Provider.of<Ads>(context).fetchAndSetFavoriteItems().then((_) {
            adsData = adsProvider.favoriteItems;
            _isLoading = false;
          });
        }
      });
    }
    _isInit = false;
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
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : AdsGrid(adsData),
            ],
          );
  }
}
