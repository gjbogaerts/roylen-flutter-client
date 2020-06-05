import 'package:flutter/foundation.dart';

class User {
  final String screenName;
  final String email;
  final String avatar;
  final String password;
  final String id;
  final String token;
  final List favoriteAds;
  final int nix;

  User({
    @required this.screenName,
    @required this.email,
    @required this.avatar,
    @required this.password,
    this.favoriteAds,
    this.id = '',
    this.token = '',
    this.nix = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        screenName: json['screenName'],
        email: json['email'],
        avatar: json['avatar'],
        password: '',
        favoriteAds: json['favoriteAds'],
        id: json['_id'],
        token: json['token'],
        nix: json['nix']);
  }
}
