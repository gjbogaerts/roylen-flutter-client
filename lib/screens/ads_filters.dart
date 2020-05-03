import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../models/ad.dart';
import '../widgets/ads_grid.dart';
import '../widgets/background.dart';

class AdsFilters extends StatefulWidget {
  static const routeName = '/ads-filters';
  final Map<String, dynamic> _elements;
  AdsFilters(this._elements);

  @override
  _AdsFiltersState createState() => _AdsFiltersState();
}

class _AdsFiltersState extends State<AdsFilters> {
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
        Provider.of<Ads>(context)
            .fetchAndSetFilteredItems(widget._elements)
            .then((_) {
          adsData = adsProvider.filteredItems;
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
