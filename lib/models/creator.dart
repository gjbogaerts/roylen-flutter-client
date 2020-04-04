import 'package:flutter/foundation.dart';
// import 'dart:convert';

class Creator {
  String email;
  String avatar;
  String screenName;

  Creator({
    @required this.email,
    @required this.avatar,
    @required this.screenName,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      avatar: json['avatar'],
      email: json['email'],
      screenName: json['screenName'],
    );
  }
}
