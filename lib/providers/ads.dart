import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/ad.dart';
import '../models/user.dart';
import '../utils/api_key.dart';
import '../utils/content_type.dart';
import '../utils/server_interface.dart';

enum ReturnMode { Search, Favorites, Filtered, All }

class Ads with ChangeNotifier {
  final String baseUrl = ServerInterface.getBaseUrl();
  final String apiKey = ApiKey.getKey();
  User _user;
  String _searchTerm;
  Map _filters;
  ReturnMode _mode = ReturnMode.All;

  List<Ad> _items = [];
  List<Ad> _favoriteItems = [];
  List<Ad> _searchItems = [];
  List<Ad> _filteredItems = [];

  Ads(this._user, this._items);

  List<Ad> get items {
    return [..._items];
  }

  List<Ad> get favoriteItems {
    return [..._favoriteItems];
  }

  List<Ad> get searchItems {
    return [..._searchItems];
  }

  List<Ad> get filteredItems {
    return [..._filteredItems];
  }

  User get user {
    return _user;
  }

  ReturnMode get mode {
    return _mode;
  }

  String get searchTerm {
    return _searchTerm;
  }

  void setSearchTerm(String q) {
    _searchTerm = q;
    notifyListeners();
  }

  Map get filters {
    return _filters;
  }

  void setFilters(Map f) {
    _filters = f;
    notifyListeners();
  }

  Ad getById(String id) {
    return _items.firstWhere((it) => it.id == id);
  }

  Future<bool> adPicToAd(
      String adId, List<Map<String, dynamic>> imagesDataList) async {
    final url = '$baseUrl/api/ads/addPic';
    final token = user.token;
    try {
      var _req = http.MultipartRequest('POST', Uri.parse(url));
      imagesDataList.forEach((_pic) {
        var _bytes = _pic['bytes'];
        List<int> _imageData = _bytes.buffer
            .asUint8List(_bytes.offsetInBytes, _bytes.lengthInBytes);
        String _name = _pic['name'];
        _name = _name.toLowerCase();
        _name = _name.replaceAll('heic', 'jpeg');
        var _file = http.MultipartFile.fromBytes('filename', _imageData,
            filename: _name,
            contentType: ContentType.getContentTypeAsMap(_name));
        _req.files.add(_file);
      });
      _req.fields['adId'] = adId;
      _req.headers.putIfAbsent('Authorization', () => 'Bearer $token');
      _req.headers.putIfAbsent('x-api-key', () => apiKey);
      var uriResponse = await _req.send();
      if (uriResponse.statusCode != 200) {
        print('fout: ${uriResponse.stream.bytesToString()}');
        return false;
      }
      await http.Response.fromStream(uriResponse);
      await fetchAndSetItems();
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<bool> removePicFromAd(String adId, String uri) async {
    final _token = user.token;
    final _url = '$baseUrl/api/ads/removePic';
    try {
      var _response = await http.post(
        _url,
        headers: {
          'content-type': 'application/json',
          'x-api-key': apiKey,
          'Authorization': 'Bearer $_token'
        },
        body: json.encode({'adId': adId, 'picUri': uri}),
      );
      if (_response.statusCode != 200) {
        print(_response.body);
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Ad>> fetchCategoryItems(
      String categoryType, String categoryName) async {
    final _url = '$baseUrl/api/ads/category/$categoryType/$categoryName';
    try {
      var _response = await http.get(_url,
          headers: {'content-type': 'application/json', 'x-api-key': apiKey});
      final adsData = json.decode(_response.body) as List<dynamic>;
      final List<Ad> loadedAds = [];

      adsData.forEach((it) {
        loadedAds.add(Ad.fromJson(it));
      });
      return loadedAds;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<Ad>> fetchAndSetFilteredItems(Map _filter) async {
    final _url = '$baseUrl/api/ads/filter';
    try {
      var _response = await http.post(_url,
          headers: {'content-type': 'application/json', 'x-api-key': apiKey},
          body: json.encode(_filter));
      List<Ad> _loadedAds = [];
      final adsData = json.decode(_response.body) as List<dynamic>;
      adsData.forEach((element) {
        _loadedAds.add(Ad.fromJson(element));
      });
      _filteredItems = _loadedAds;
      return _loadedAds;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> fetchAndSetSearchItems(String q) async {
    _mode = ReturnMode.Search;
    final url = baseUrl + '/api/ads/q/$q';
    try {
      final response = await http.get(url, headers: {'x-api-key': apiKey});
      final adsData = json.decode(response.body) as List<dynamic>;
      final List<Ad> loadedAds = [];
      adsData.forEach((it) {
        loadedAds.add(Ad.fromJson(it));
      });
      _searchItems = loadedAds;
    } catch (err) {
      print('Fout: $err');
    } finally {
      notifyListeners();
    }
  }

  Future<List<Ad>> fetchAndSetItems() async {
    _mode = ReturnMode.All;
    final url = baseUrl + '/api/ads';
    try {
      final response = await http.get(url, headers: {'x-api-key': apiKey});
      final adsData = json.decode(response.body) as List<dynamic>;
      final List<Ad> loadedAds = [];

      adsData.forEach((it) {
        loadedAds.add(Ad.fromJson(it));
      });
      _items = loadedAds;
      return loadedAds;
    } catch (err) {
      print('Fout: Error $err');
      throw Exception(err);
    }
  }

  Future<List<Ad>> fetchAndSetFavoriteItems() async {
    _mode = ReturnMode.Favorites;
    if (_user == null) {
      return [];
    }
    final _url = baseUrl + '/api/ads/saved/${_user.id}';
    final _token = _user.token;
    try {
      final _response = await http.get(_url,
          headers: {'Authorization': 'Bearer $_token', 'x-api-key': apiKey});
      final _adsData = json.decode(_response.body) as List<dynamic>;
      final List<Ad> _loadedAds = [];
      _adsData.forEach((it) {
        _loadedAds.add(Ad.fromJson(it));
      });
      _favoriteItems = _loadedAds;
      return _loadedAds;
    } catch (err) {
      print('Fout: ' + err.toString());
      throw Exception(err.toString());
    }
  }

  Future<bool> setFavorite(String adId) async {
    final _url = baseUrl + '/api/favorite';
    try {
      var response = await http.post(_url,
          headers: {'content-type': 'application/json', 'x-api-key': apiKey},
          body: json.encode({'userId': '${_user.id}', 'adId': '$adId'}));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      return false;
    }
  }

  Future<bool> warnAboutAd(String adId) async {
    final _url = baseUrl + '/api/ads/warning';
    try {
      var response = await http.post(_url,
          headers: {'content-type': 'application/json', 'x-api-key': apiKey},
          body: json.encode({'adId': adId}));
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (err) {
      return true;
    }
  }

  Future<bool> removeAd(String adId) async {
    final _userId = _user.id;
    final _token = _user.token;
    final _url = baseUrl + '/api/ads/$adId/$_userId';
    try {
      var response = await http.delete(_url,
          headers: {'Authorization': 'Bearer $_token', 'x-api-key': apiKey});
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

  Future<bool> updateAd(Map<String, dynamic> adData, String token) async {
    final url = '$baseUrl/api/ads/update';
    try {
      var response = await http.post(url,
          headers: {
            'x-api-key': apiKey,
            'Authorization': 'Bearer $token',
            'content-type': 'application/json'
          },
          body: json.encode(adData));
      if (response.statusCode == 200) {
        fetchAndSetFavoriteItems();
        return true;
      } else {
        throw Exception('Error from server: ${response.body}');
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> createAd(Map<String, dynamic> adData, String token) async {
    final url = baseUrl + '/api/adCreate';
    // final url = ServerInterface.getDebugUrl() + '/api/adCreate';
    // final url = ServerInterface.getiOSDebugUrl() + '/api/adCreate';
    try {
      var _req = http.MultipartRequest('POST', Uri.parse(url));
      var _picData = adData['picture'] as List<Map<String, dynamic>>;
      _picData.forEach((_pic) {
        var _bytes = _pic['bytes'];
        List<int> _imageData = _bytes.buffer
            .asUint8List(_bytes.offsetInBytes, _bytes.lengthInBytes);
        String _name = _pic['name'];
        _name = _name.toLowerCase();
        _name = _name.replaceAll('heic', 'jpeg');
        var _file = http.MultipartFile.fromBytes('filename', _imageData,
            filename: _name,
            contentType: ContentType.getContentTypeAsMap(_name));
        _req.files.add(_file);
      });
      adData.remove('picture');
      adData.forEach((s, v) {
        _req.fields[s] = v.toString();
      });
      _req.headers.putIfAbsent('Authorization', () => 'Bearer $token');
      _req.headers.putIfAbsent('x-api-key', () => apiKey);
      var uriResponse = await _req.send();
      if (uriResponse.statusCode != 200) {
        print('fout: ${uriResponse.stream.bytesToString()}');
        return false;
      }
      await http.Response.fromStream(uriResponse);
      await fetchAndSetItems();
      // notifyListeners();
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<List<Ad>> fetchItemsFromUser(String _userId) async {
    final url = baseUrl + '/api/ads/fromUser/$_userId';
    final List<Ad> loadedAds = [];
    try {
      final response = await http.get(url, headers: {'x-api-key': apiKey});
      final adsData = json.decode(response.body) as List<dynamic>;
      adsData.forEach((it) {
        loadedAds.add(Ad.fromJson(it));
      });
      return loadedAds;
    } catch (err) {
      print('Fout: Error $err');
      return loadedAds;
    }
  }
}
