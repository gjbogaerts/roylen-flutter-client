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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Ads>(context).fetchAndSetItems(),
        builder: (context, adsResult) {
          return Stack(
            children: <Widget>[
              Background(),
              adsResult.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Builder(builder: (BuildContext context) {
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          Provider.of<Toaster>(context, listen: false)
                              .showSnackBar(context));
                      return AdsGrid(adsResult.data);
                    }),
            ],
          );
        });
  }
}
