import 'package:flutter/foundation.dart';
import './creator.dart';
import './location.dart';

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

  Ad({
    this.id = '',
    @required this.title,
    @required this.description,
    @required this.category,
    @required this.virtualPrice,
    @required this.picture,
    @required this.creator,
    @required this.adNature,
    @required this.location,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      adNature: json['adNature'],
      description: json['description'],
      category: json['category'],
      virtualPrice: json['virtualPrice'],
      picture: json['pics'][0],
      creator: Creator.fromJson(json['creator']),
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      title: json['title'],
      id: json['_id'],
    );
  }
}
