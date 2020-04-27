import 'package:flutter/foundation.dart';
// import 'dart:convert';

class Creator {
  String email;
  String avatar;
  String screenName;
  String id;

  Creator(
      {@required this.email,
      @required this.avatar,
      @required this.screenName,
      @required this.id});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
        avatar: json['avatar'],
        email: json['email'],
        screenName: json['screenName'],
        id: json['_id']);
  }
}
