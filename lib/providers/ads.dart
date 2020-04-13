import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/server_interface.dart';
import '../models/ad.dart';
// import '../models/creator.dart';
import '../models/user.dart';

class Ads with ChangeNotifier {
  final String baseUrl = ServerInterface.getBaseUrl();
  User _user;

  List<Ad> _items = [];

  Ads(this._user, this._items);

  List<Ad> get items {
    return [..._items];
  }

  User get user {
    return _user;
  }

  Ad getById(String id) {
    return _items.firstWhere((it) => it.id == id);
  }

  Future<void> fetchAndSetItems() async {
    final url = baseUrl + '/api/ads';
    try {
      final response = await http.get(url);
      final adsData = json.decode(response.body) as List<dynamic>;
      final List<Ad> loadedAds = [];

      adsData.forEach((it) {
        loadedAds.add(Ad.fromJson(it));
      });
      _items = loadedAds;
    } catch (err) {
      print('Fout: Error $err');
    } finally {
      notifyListeners();
    }
  }
}
