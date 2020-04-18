// import 'package:flutter/foundation.dart';
// import 'dart:convert';

class Location {
  List<dynamic> coordinates;
  String id;

  Location({
    this.coordinates,
    this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(coordinates: json['coordinates'], id: json['_id']);
  }
}
