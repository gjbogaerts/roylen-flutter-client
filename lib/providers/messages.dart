import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/server_interface.dart';
import '../models/user.dart';

class Messages with ChangeNotifier {
  String baseUrl = ServerInterface.getBaseUrl();
  String _err;
  User _user;
  List<Map<String, dynamic>> _items;

  Messages(this._user, this._items);

  User get user {
    return _user;
  }

  List<Map<String, dynamic>> get items {
    return [..._items];
  }

  String get err {
    return _err;
  }

  Future<bool> sendMessage(
      {String toId, String adId, String adTitle, String message}) async {
    var _url = baseUrl + '/api/message';
    try {
      var _response = await http.post(_url,
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer ${_user.token}'
          },
          body: json.encode({
            'sender`name': _user.screenName,
            'fromId': _user.id,
            'toId': toId,
            'adId': adId,
            'adTitle': adTitle,
            'message': message
          }));
      if (_response.statusCode != 200) {
        _err = json.decode((_response.body));
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
    } catch (err) {
      _err = err;
      notifyListeners();
      return false;
    }
  }
}
