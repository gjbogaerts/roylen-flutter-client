import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../models/ad.dart';
import '../widgets/ads_grid.dart';
import '../widgets/background.dart';

class AdsFavorites extends StatefulWidget {
  static const routeName = '/ads-favorites';

  @override
  _AdsFavoritesState createState() => _AdsFavoritesState();
}

class _AdsFavoritesState extends State<AdsFavorites> {
  List<Ad> adsData;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var adsProvider = Provider.of<Ads>(context);
    if (_isInit) {
      setState(() {
        _isLoading = true;
        Provider.of<Ads>(context).fetchAndSetFavoriteItems().then((_) {
          adsData = adsProvider.favoriteItems;
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
