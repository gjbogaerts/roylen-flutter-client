import 'package:flutter/foundation.dart';

class User {
  final String screenName;
  final String email;
  final String avatar;
  final String password;
  final String id;
  final String token;
  final int nix;

  User({
    @required this.screenName,
    @required this.email,
    @required this.avatar,
    @required this.password,
    this.id = '',
    this.token = '',
    this.nix = 0,
  });
}
