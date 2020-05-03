import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../providers/toaster.dart';
import '../models/ad.dart';
import '../widgets/ads_grid.dart';
import '../widgets/background.dart';

class AdsList extends StatefulWidget {
  static const routeName = '/ads-list';

  @override
  _AdsListState createState() => _AdsListState();
}

class _AdsListState extends State<AdsList> {
  List<Ad> adsData = [];
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var adsProvider = Provider.of<Ads>(context);
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      adsProvider.fetchAndSetItems().then((_) {
        adsData = adsProvider.items;
        setState(() {
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
            : Builder(builder: (BuildContext context) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Provider.of<Toaster>(context).showSnackBar(context));
                return AdsGrid(adsData);
              }),
      ],
    );
  }
}
