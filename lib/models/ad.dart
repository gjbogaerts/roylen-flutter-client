import 'package:flutter/foundation.dart';
import './creator.dart';
import './location.dart';
import './offer.dart';

class Ad with ChangeNotifier {
  String id;
  final String title;
  final String description;
  final String category;
  final int virtualPrice;
  final String picture;
  final Creator creator;
  final String adNature;
  final Location location;
  final String dateAdded;
  List<Offer> offers;

  Ad(
      {this.id = '',
      @required this.title,
      @required this.description,
      @required this.category,
      @required this.virtualPrice,
      @required this.picture,
      @required this.creator,
      @required this.adNature,
      @required this.location,
      @required this.dateAdded,
      this.offers});

  factory Ad.fromJson(Map<String, dynamic> json) {
    var offers = json['offers'] as List<dynamic>;
    var loadedOffers = <Offer>[];
    offers.forEach((element) {
      // print(element);
      loadedOffers.add(Offer.fromJson(element));
    });

    return Ad(
        adNature: json['adNature'],
        description: json['description'],
        category: json['category'],
        virtualPrice: json['virtualPrice'],
        picture: json['pics'][0],
        creator: Creator.fromJson(json['creator']),
        location: json['location'] != null
            ? Location.fromJson(json['location'])
            : null,
        title: json['title'],
        id: json['_id'],
        dateAdded: json['dateAdded'],
        offers: loadedOffers);
  }
}
