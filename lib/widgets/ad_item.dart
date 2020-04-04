import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/ads.dart';
import '../utils/server_interface.dart';
import '../screens/ads_detail.dart';

class AdItem extends StatelessWidget {
  final String id;

  AdItem(this.id);

  @override
  Widget build(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    final ad = Provider.of<Ads>(context).getById(id);
    final baseUrl = ServerInterface.getBaseUrl();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            tag: id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/image9.jpeg'),
              image: ad.picture != null
                  ? NetworkImage('$baseUrl${ad.picture}')
                  : AssetImage('assets/images/image9.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AdsDetail.routeName, arguments: id);
          },
        ),
        header: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(ad.title, textAlign: TextAlign.center),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(ad.category),
              Text('${ad.virtualPrice.toString()} nix'),
            ],
          ),
        ),
      ),
    );
  }
}
