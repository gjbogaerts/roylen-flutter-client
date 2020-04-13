import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ads.dart';
import '../widgets/ads_grid.dart';
import '../widgets/app_drawer.dart';

class AdsList extends StatefulWidget {
  static const routeName = '/ads-list';

  @override
  _AdsListState createState() => _AdsListState();
}

class _AdsListState extends State<AdsList> {
  var _isInit = true;
  var _isLoading = false;
  String _message;

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

  void onAfterBuild(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        _message,
        textAlign: TextAlign.center,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var _arguments =
        ModalRoute.of(context).settings.arguments as Map<String, int>;
    if (_arguments != null) {
      if (_arguments['login'] == 0 && _arguments['register'] == 1) {
        _message = 'Je bent nu geregistreerd en ingelogd in de app.';
      }
      if (_arguments['login'] == 1 && _arguments['register'] == 0) {
        _message = 'Je bent nu ingelogd.';
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text('Ruilen?')),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Builder(builder: (BuildContext context) {
              if (_message != null)
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => onAfterBuild(context));
              return AdsGrid();
            }),
    );
  }
}
