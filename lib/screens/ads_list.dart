import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../widgets/ads_grid.dart';

class AdsList extends StatefulWidget {
  static const routeName = '/ads-list';
  @override
  _AdsListState createState() => _AdsListState();
}

class _AdsListState extends State<AdsList> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Ruilen?')),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : AdsGrid());
  }
}
