import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../providers/toaster.dart';
import '../widgets/ads_grid.dart';

class AdsList extends StatefulWidget {
  static const routeName = '/ads-list';
  final bool filterOnFavs;

  AdsList({this.filterOnFavs = false});

  @override
  _AdsListState createState() => _AdsListState();
}

class _AdsListState extends State<AdsList> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    var adsProvider = Provider.of<Ads>(context);
    if (adsProvider.items.length == 0) {
      if (_isInit) {
        setState(() {
          _isLoading = true;
        });
        Provider.of<Ads>(context).fetchAndSetItems().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void onAfterBuild(BuildContext context) {
    var toaster = Provider.of<Toaster>(context);
    if (toaster.message) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        content: Text(
          toaster.getMessage(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body2,
        ),
      ));
      toaster.clearMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Builder(builder: (BuildContext context) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => onAfterBuild(context));
            return AdsGrid();
          });
  }
}
