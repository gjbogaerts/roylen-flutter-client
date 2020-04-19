import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../providers/toaster.dart';
import '../widgets/ads_grid.dart';

class AdsFavoriteList extends StatefulWidget {
  static const routeName = '/ads-favorite-list';

  @override
  _AdsFavoriteListState createState() => _AdsFavoriteListState();
}

class _AdsFavoriteListState extends State<AdsFavoriteList> {
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _isLoading = true;
    _fetchFavorites();
  }

  void _fetchFavorites() async {
    await Provider.of<Ads>(context, listen: false).fetchAndSetFavoriteItems();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Builder(builder: (BuildContext context) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => Provider.of<Toaster>(context).showSnackBar(context));
            return AdsGrid(
              favsOnly: true,
            );
          });
  }
}
