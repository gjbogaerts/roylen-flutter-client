import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ads.dart';
import './ad_item.dart';

class AdsGrid extends StatelessWidget {
  final bool favsOnly;
  AdsGrid({this.favsOnly = false});
  @override
  Widget build(BuildContext context) {
    final adsData = favsOnly
        ? Provider.of<Ads>(context).favoriteItems
        : Provider.of<Ads>(context).items;
    // print(adsData);
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: adsData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2 / 3),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: adsData[index],
          child: AdItem(adsData[index].id),
        );
      },
    );
  }
}
