import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/server_interface.dart';
import '../models/user.dart';
import '../utils/content_type.dart';
import '../utils/api_key.dart';

class Auth with ChangeNotifier {
  final String baseUrl = ServerInterface.getBaseUrl();

  final String apiKey = ApiKey.getKey();
  String _token;
  String _userId;
  String _email;
  String _screenName;
  List<dynamic> _favoriteAds;
  int _nix;
  String _avatar;

  bool get isAuth {
    return _token != null;
  }

  bool _isAuth() {
    return _token != null;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _email = null;
    _screenName = null;
    _nix = null;
    _avatar = null;
    _favoriteAds = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    notifyListeners();
  }

  Future<bool> finishResetPasswordSequence(String key, String pw) async {
    final _url = baseUrl + '/api/confirmResetPassword';
    try {
      final _response = await http.post(_url,
          headers: {'content-type': 'application/json', 'x-api-key': apiKey},
          body: json.encode({'key': key, 'pw': pw}));
      if (_response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
        // print(_response.body.toString());
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> changeProfile(String _imageLocation, String _newEmail) async {
    final _url = '$baseUrl/api/profile';
    // final _url = '${ServerInterface.getDebugUrl()}/api/profile';
    try {
      var _req = http.MultipartRequest('POST', Uri.parse(_url));
      if (_imageLocation != null) {
        var contentType = ContentType.getContentType(_imageLocation);
        var file = await http.MultipartFile.fromPath('filename', _imageLocation,
            contentType: MediaType.parse(contentType));
        _req.files.add(file);
      }
      _req.headers.putIfAbsent('Authorization', () => 'Bearer $_token');
      _req.headers.putIfAbsent('content-type', () => 'application/json');
      _req.headers.putIfAbsent('x-api-key', () => apiKey);
      _req.fields['email'] = _newEmail;
      var _imageData = await _req.send();

      if (_imageData.statusCode != 200) {
        print('status: ${_imageData.statusCode}');
        print(_imageData.stream.bytesToString());
        throw Exception(
            'Het lukte niet om je wijzingen op te slaan. Probeer het later nog eens.');
      }
      var doc = await http.Response.fromStream(_imageData);
      var data = json.decode(doc.body);
      data = data['doc'];
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('email', data['email']);
      prefs.setString('avatar', data['avatar']);
      _email = data['email'];
      _avatar = data['avatar'];
      notifyListeners();
      return true;
    } catch (err) {
      notifyListeners();
      throw Exception(
          '$err: Er ging iets mis in de verbinding met de server. Probeer het later nog eens.');
    }
  }

  Future<bool> startResetPasswordSequence(String email) async {
    final _url = baseUrl + '/api/resetPassword';
    try {
      final _response = await http.post(_url,
          headers: {'content-type': 'application/json', 'x-api-key': apiKey},
          body: json.encode({'email': email}));
      if (_response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
        // print(_response.body.toString());
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return Timer(Duration(seconds: 3), () {
        return false;
      });
    } else {
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, dynamic>;
      _token = extractedUserData['token'];
      _userId = extractedUserData['_id'];
      _email = extractedUserData['email'];
      _screenName = extractedUserData['screenName'];
      // print(extractedUserData);
      // print(extractedUserData['favoriteAds']);
      _favoriteAds = json.decode(extractedUserData['favoriteAds']);
      _nix = extractedUserData['nix'];
      _avatar = extractedUserData['avatar'];
      notifyListeners();
      return Timer(Duration(seconds: 2), () {
        return true;
      });
    }
    // return true;
  }

  User getUser() {
    if (_isAuth()) {
      return User(
          avatar: _avatar,
          email: _email,
          screenName: _screenName,
          favoriteAds: _favoriteAds,
          id: _userId,
          nix: _nix,
          token: _token,
          password: '');
    }
    return null;
  }

  Future<bool> loginUser({String email, String password}) async {
    try {
      var uriResponse = await http.post(
        '$baseUrl/api/signin',
        headers: {'content-type': 'application/json', 'x-api-key': apiKey},
        body: json.encode({'email': email, 'password': password}),
      );

      var _userData = json.decode(uriResponse.body);
      // print(_userData);
      if (_userData['token'] == null) {
        // print('not token found');
        return false;
      }
      _token = _userData['token'];
      _email = _userData['email'];
      _screenName = _userData['screenName'];
      _userId = _userData['_id'];
      _avatar = _userData['avatar'];
      _favoriteAds = _userData['favoriteAds'];
      _nix = _userData['nix'];
      final prefs = await SharedPreferences.getInstance();
      var _userDataToStore = _userData;
      _userDataToStore['favoriteAds'] = json.encode(_userData['favoriteAds']);
      final stringToStore = json.encode(_userDataToStore);
      await prefs.setString('userData', stringToStore);
      notifyListeners();
      return true;
    } catch (err) {
      print('Fout $err');
      return false;
    }
  }

  void updateFavorite(String adId) async {
    if (_favoriteAds.any((element) => element == adId)) {
      _favoriteAds.remove(adId);
    } else {
      _favoriteAds.add(adId);
    }
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('favoriteAds', json.encode(_favoriteAds));
    notifyListeners();
  }

  Future<bool> registerUser({
    String email,
    String password,
    String screenName,
    String avatar,
  }) async {
    try {
      var uriResponse = await http.post('$baseUrl/api/signup',
          headers: {'content-type': 'application/json', 'x-api-key': apiKey},
          body: json.encode({
            'email': email,
            'password': password,
            'screenName': screenName
          }));
      var _userData = json.decode(uriResponse.body);
      if (_userData == null) {
        return false;
      }
      _token = _userData['token'];
      _email = _userData['email'];
      _screenName = _userData['screenName'];
      _userId = _userData['_id'];
      _avatar = avatar;
      _nix = _userData['nix'];
      _favoriteAds = [];
      var _req =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/api/profile'));
      if (avatar.isNotEmpty) {
        var contentType = ContentType.getContentType(avatar);
        var file = await http.MultipartFile.fromPath('filename', avatar,
            contentType: MediaType.parse(contentType));

        _req.files.add(file);
      }

      _req.headers.putIfAbsent('Authorization', () => 'Bearer $_token');
      _req.headers.putIfAbsent('x-api-key', () => apiKey);
      _req.fields['email'] = email;
      var _imageData = await _req.send();
      if (_imageData.statusCode != 200) {
        print('no imagedata');
        return false;
      }

      // await http.Response.fromStream(_imageData);

      var prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token);
      prefs.setString('email', _userData['email']);
      prefs.setString('avatar', avatar);
      prefs.setString('_id', _userData['id']);
      prefs.setString('screenName', _userData['screenName']);
      prefs.setInt('nix', _userData['nix']);
      prefs.setString('favoriteAds', json.encode([]));
      notifyListeners();
      return true;
    } catch (err) {
      print('fouje');
      print(err);
      return false;
    } finally {
      notifyListeners();
    }

    // client.close();
  }
}
