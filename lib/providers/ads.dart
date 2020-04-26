import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../utils/server_interface.dart';
import '../models/ad.dart';
// import '../models/creator.dart';
import '../models/user.dart';
import '../utils/content_type.dart';

enum ReturnMode { Search, Favorites, Filtered, All }

class Ads with ChangeNotifier {
  final String baseUrl = ServerInterface.getBaseUrl();
  User _user;
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

  Ad getById(String id) {
    return _items.firstWhere((it) => it.id == id);
  }

  Future<void> fetchAndSetFilteredItems(Map _filter) async {
    _mode = ReturnMode.Filtered;
    _filteredItems = [];
    var _category = _filter['category'] == null ||
            _filter['category'] == 'Kies je categorie'
        ? null
        : _filter['category'];
    //category is not null, first we pick all up within this category
    if (_category != null) {
      final url = baseUrl + '/api/ads/c/$_category';
      try {
        final _response = await http.get(url);
        final _adsData = json.decode(_response.body) as List<dynamic>;
        // print(url);
        // print(_adsData);
        final List<Ad> _loadedAds = [];
        _adsData.forEach((it) {
          _loadedAds.add(Ad.fromJson(it));
        });
        _filteredItems = _loadedAds;
      } catch (err) {
        print('Fout: $err');
      }
    } else {
      _filteredItems = _items;
    }
    // print('after category: ${_filteredItems.length}');

    //now that we have _filteredItems, we can check them for price
    if (_filter['priceMin'] != null && _filter['priceMin'] != '') {
      _filteredItems.retainWhere(
          (it) => it.virtualPrice > int.parse(_filter['priceMin']));
    }
    if (_filter['priceMax'] != null && _filter['priceMax'] != '') {
      _filteredItems.retainWhere(
          (it) => it.virtualPrice < int.parse(_filter['priceMax']));
    }
    // print('after pricecheck: ${_filteredItems.length}');
    // we need to check for adnature:
    _filteredItems.retainWhere((it) => it.adNature == _filter['adNature']);
    // print('after adNature: ${_filteredItems.length}');
    //finally, if distance is set, we can get all distance filtered items from the server and get the cross section with the result and _filteredItems;
    if (_filter['maxDistance'] != null) {
      // print(
      // 'in distance: ${_filter['maxDistance']}, ${_filter['latitude']}, ${_filter['longitude']} ');
      final _distanceUrl = baseUrl + '/api/ads/withDistance';
      try {
        final _distanceResponse = await http.post(_distanceUrl,
            headers: {'content-type': 'application/json'},
            body: json.encode({
              'dist': _filter['maxDistance'],
              'latitude': _filter['latitude'],
              'longitude': _filter['longitude']
            }));
        final _adsDistanceData =
            json.decode(_distanceResponse.body) as List<dynamic>;
        final List<Ad> _loadedDistanceAds = [];
        _adsDistanceData.forEach((it) {
          _loadedDistanceAds.add(Ad.fromJson(it));
        });
        _loadedDistanceAds.forEach((item) {
          _filteredItems.retainWhere((it) => it.id == item.id);
        });
      } catch (err) {
        print('Fout: $err');
      }
    }
    // print('after distance: ${_filteredItems.length}');
    notifyListeners();
  }

  Future<void> fetchAndSetSearchItems(String q) async {
    _mode = ReturnMode.Search;
    final url = baseUrl + '/api/ads/q/$q';
    try {
      final response = await http.get(url);
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

  Future<void> fetchAndSetItems() async {
    _mode = ReturnMode.All;
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

  Future<void> fetchAndSetFavoriteItems() async {
    _mode = ReturnMode.Favorites;
    final _url = baseUrl + '/api/ads/saved/${_user.id}';
    final _token = _user.token;
    try {
      final _response =
          await http.get(_url, headers: {'Authorization': 'Bearer $_token'});
      final _adsData = json.decode(_response.body) as List<dynamic>;
      final List<Ad> _loadedAds = [];
      _adsData.forEach((it) {
        _loadedAds.add(Ad.fromJson(it));
      });
      _favoriteItems = _loadedAds;
      notifyListeners();
    } catch (err) {
      print('Fout: ' + err.toString());
    }
  }

  Future<bool> setFavorite(String adId) async {
    final _url = baseUrl + '/api/favorite';
    try {
      var response = await http.post(_url,
          headers: {'content-type': 'application/json'},
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
          headers: {'content-type': 'application/json'},
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
}
