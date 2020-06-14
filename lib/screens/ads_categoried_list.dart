import 'package:Roylen/widgets/ads_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/background.dart';
import '../widgets/ads_grid.dart';
import '../providers/ads.dart';

class AdsCategoriedList extends StatefulWidget {
  static const routeName = '/ads-categoried-list';

  AdsCategoriedList();

  @override
  _AdsCategoriedListState createState() => _AdsCategoriedListState();
}

class _AdsCategoriedListState extends State<AdsCategoriedList> {
  String _categoryType;
  String _category;

  @override
  Widget build(BuildContext context) {
    var _args = ModalRoute.of(context).settings.arguments as Map;
    setState(() {
      _categoryType = _args['categoryType'];
      _category = _args['category'];
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(_categoryType == 'creator' ? 'Adverteerder' : _category),
      ),
      // drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          Background(),
          FutureBuilder(
            future: _categoryType == 'creator'
                ? Provider.of<Ads>(context).fetchItemsFromUser(_category)
                : Provider.of<Ads>(context)
                    .fetchCategoryItems(_categoryType, _category),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? CircularProgressIndicator()
                  : AdsGrid(snapshot.data);
            },
          )
        ],
      ),
    );
  }
}
