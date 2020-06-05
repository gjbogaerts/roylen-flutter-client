import 'package:flutter/foundation.dart';
import './creator.dart';
import './location.dart';
import './offer.dart';

class Ad with ChangeNotifier {
  String id;
  final String title;
  final String description;
  final String category;
  final String mainCategory;
  final String subCategory;
  final String subSubCategory;
  final String ageCategory;
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
      this.category = '',
      this.mainCategory = '',
      this.subCategory = '',
      this.subSubCategory = '',
      this.ageCategory = '',
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
      if (element is Map) {
        loadedOffers.add(Offer.fromJson(element));
      }
    });

    return Ad(
        adNature: json['adNature'],
        description: json['description'],
        category: json['category'] == null ? '' : json['category'],
        mainCategory: json['mainCategory'] == null
            ? json['category']
            : json['mainCategory'],
        subCategory: json['subCategory'] == null ? '' : json['subCategory'],
        subSubCategory:
            json['subSubCategory'] == null ? '' : json['subSubCategory'],
        ageCategory: json['ageCategory'] == null ? '' : json['ageCategory'],
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
