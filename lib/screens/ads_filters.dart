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
  Future<List<Ad>> adsData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adsData =
        Provider.of<Ads>(context).fetchAndSetFilteredItems(widget._elements);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(),
        FutureBuilder(
            future: adsData,
            builder: (ctx, result) {
              return result.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : AdsGrid(result.data);
            })
      ],
    );
  }
}
