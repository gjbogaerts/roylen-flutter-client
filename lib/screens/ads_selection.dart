import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../models/ad.dart';
import '../widgets/ads_grid.dart';

class AdsSelection extends StatefulWidget {
  static const routeName = '/ads-selection';
  final ReturnMode _mode;
  AdsSelection(this._mode);

  @override
  _AdsSelectionState createState() => _AdsSelectionState();
}

class _AdsSelectionState extends State<AdsSelection> {
  List<Ad> adsData = [];
  bool _isInit = true;
  bool _isLoading = false;
  ReturnMode _oldMode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var adsProvider = Provider.of<Ads>(context);
    var _newMode = widget._mode;
    if (_newMode != _oldMode) {
      _isInit = true;
      _oldMode = widget._mode;
    }

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      switch (widget._mode) {
        case ReturnMode.All:
          return;
        case ReturnMode.Search:
          setState(() {
            adsData = adsProvider.searchItems;
            _isLoading = false;
          });

          break;
        case ReturnMode.Favorites:
          adsProvider.fetchAndSetFavoriteItems().then((_) {
            setState(() {
              adsData = adsProvider.favoriteItems;
              _isLoading = false;
            });
          });

          break;
        case ReturnMode.Filtered:
          adsProvider.fetchAndSetItems().then((_) {
            setState(() {
              adsData = adsProvider.items;
              _isLoading = false;
            });
          });
          break;
      }
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AdsGrid(adsData);
  }
}
