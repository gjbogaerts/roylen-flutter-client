import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../utils/server_interface.dart';
import '../models/ad.dart';
// import '../models/creator.dart';
import '../models/user.dart';
import '../utils/content_type.dart';

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

  Future<bool> removeAd(String adId) async {
    final _userId = _user.id;
    final _token = _user.token;
    final _url = baseUrl + '/api/ads/$adId/$_userId';
    try {
      var response =
          await http.delete(_url, headers: {'Authorization': 'Bearer $_token'});
      _items.removeWhere((it) => it.id == adId);
      notifyListeners();
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (err) {
      print('Fouten Deleten: $err');
      return false;
    }
  }

  Future<bool> createAd(Map<String, dynamic> adData, String token) async {
    final url = baseUrl + '/api/adCreate';
    final contentType = ContentType.getContentType(adData['picture']);
    try {
      var _req = http.MultipartRequest('POST', Uri.parse(url));
      var _file = await http.MultipartFile.fromPath(
          'filename', adData['picture'],
          contentType: MediaType.parse(contentType));
      _req.files.add(_file);
      adData.forEach((s, v) {
        _req.fields[s] = v.toString();
      });
      _req.headers.putIfAbsent('Authorization', () => 'Bearer $token');
      var uriResponse = await _req.send();
      if (uriResponse.statusCode != 200) {
        return false;
      }
      await http.Response.fromStream(uriResponse);
      await fetchAndSetItems();
      // notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<List<Ad>> fetchItemsFromUser(String _userId) async {
    final url = baseUrl + '/api/ads/fromUser/$_userId';
    final List<Ad> loadedAds = [];
    try {
      final response = await http.get(url);
      final adsData = json.decode(response.body) as List<dynamic>;
      adsData.forEach((it) {
        loadedAds.add(Ad.fromJson(it));
      });
      notifyListeners();
      return loadedAds;
    } catch (err) {
      print('Fout: Error $err');
      return loadedAds;
    }
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
