import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ad.dart';
import './ad_item.dart';

class AdsGrid extends StatelessWidget {
  // final bool favsOnly;
  final List<Ad> adsData;
  AdsGrid(this.adsData);
  @override
  Widget build(BuildContext context) {
    // print(adsData);
    return adsData.length == 0
        ? Center(
            child: Text('Geen advertenties te tonen.'),
          )
        : GridView.builder(
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
