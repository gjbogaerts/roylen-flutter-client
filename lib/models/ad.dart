import 'package:flutter/foundation.dart';
import 'dart:convert';
import './creator.dart';

class Ad {
  String id = '';
  String title;
  String description;
  String category;
  int virtualPrice;
  String picture;
  Creator creator;
  String adNature;
  String location;

  Ad({
    this.id,
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
      picture: json['picture'],
      creator: Creator.fromJson(json['creator']),
      location: null,
      title: json['title'],
      id: json['id'],
    );
  }
}
