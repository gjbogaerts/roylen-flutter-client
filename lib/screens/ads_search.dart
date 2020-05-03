import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../models/ad.dart';
import '../widgets/ads_grid.dart';
import '../widgets/background.dart';

class AdsSearch extends StatefulWidget {
  static const routeName = '/ads-search';
  final String _q;

  AdsSearch(this._q);

  @override
  _AdsSearchState createState() => _AdsSearchState();
}

class _AdsSearchState extends State<AdsSearch> {
  List<Ad> adsData;
  bool _isInit = true;
  bool _isLoading = true;
  String _query;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var adsProvider = Provider.of<Ads>(context);
    setState(() {
      if (_query != widget._q) {
        _isInit = true;
        _query = widget._q;
      }
    });
    if (_isInit) {
      adsProvider.fetchAndSetSearchItems(_query).then((_) {
        setState(() {
          adsData = adsProvider.searchItems;
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
            : AdsGrid(adsData)
      ],
    );
  }
}
