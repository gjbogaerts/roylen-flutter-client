import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/server_interface.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../utils/api_key.dart';

class Messages with ChangeNotifier {
  String baseUrl = ServerInterface.getBaseUrl();
  String apiKey = ApiKey.getKey();
  String _err;
  User _user;
  List<Message> _items;

  Messages(this._user, this._items);

  User get user {
    return _user;
  }

  List<Message> get items {
    return [..._items];
  }

  String get err {
    return _err;
  }

  Future<void> markAsRead(String messageId, bool isRead) async {
    String _url;
    if (isRead) {
      _url = '$baseUrl/api/message/markUnread';
    } else {
      _url = '$baseUrl/api/message/markRead';
    }
    try {
      var _response = await http.post(_url,
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer ${_user.token}',
            'x-api-key': apiKey
          },
          body: json.encode({'messageId': messageId}));
      if (_response.statusCode != 200) {
        throw Exception(
            'Er is iets misgegaan tijdens het verwerken van je verzoek. Probeer het later nog eens.');
      }
      _items.forEach((i) {
        if (i.id == messageId) {
          i.isRead = !isRead;
        }
      });
      notifyListeners();
    } catch (err) {
      throw Exception(
          'Er is iets misgegaan tijdens het verwerken van je verzoek. Probeer het later nog eens.');
    }
  }

  Future<List<Message>> fetchAndSetMessages() async {
    var _url = '$baseUrl/api/message/${_user.id}';
    try {
      var _response = await http.get(_url, headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${_user.token}',
        'x-api-key': apiKey
      });
      var _responseData = json.decode(_response.body) as List<dynamic>;
      final List<Message> _loadedMessages = [];
      _responseData.forEach((it) {
        _loadedMessages.add(Message.fromJson(it));
      });
      _items = _loadedMessages;
      return _loadedMessages;
      // notifyListeners();
    } catch (err) {
      print(err);
      throw Exception();
      // return null;
    }
  }

  Future<bool> sendContactMessage(String msg, String email, String name) async {
    var _url = '$baseUrl/api/message/contact';
    try {
      var _response = await http.post(_url,
          headers: {'content-type': 'application/json', 'x-api-key': apiKey},
          body: json.encode({'msg': msg, 'email': email, 'name': name}));

      if (_response.statusCode == 200) {
        notifyListeners();
        return true;
      }
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> sendMessage(
      {String toId, String adId, String adTitle, String message}) async {
    var _url = baseUrl + '/api/message';
    try {
      var _response = await http.post(_url,
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer ${_user.token}',
            'x-api-key': apiKey
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
        _err = json.decode(_response.body);
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
