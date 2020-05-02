import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
        print(_response.body.toString());
        return false;
      }
    } catch (err) {
      print(err);
      return false;
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
        print(_response.body.toString());
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    } else {
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, dynamic>;
      _token = extractedUserData['token'];
      _userId = extractedUserData['_id'];
      _email = extractedUserData['email'];
      _screenName = extractedUserData['screenName'];
      _nix = extractedUserData['nix'];
      _avatar = extractedUserData['avatar'];
      notifyListeners();
      return true;
    }
  }

  User getUser() {
    if (_isAuth()) {
      return User(
          avatar: _avatar,
          email: _email,
          screenName: _screenName,
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
      if (_userData['token'] == null) {
        // print('not token found');
        return false;
      }
      _token = _userData['token'];
      _email = _userData['email'];
      _screenName = _userData['screenName'];
      _userId = _userData['_id'];
      _avatar = _userData['avatar'];
      _nix = _userData['nix'];
      final prefs = await SharedPreferences.getInstance();
      final stringToStore = json.encode(_userData);
      await prefs.setString('userData', stringToStore);
      notifyListeners();
      return true;
    } catch (err) {
      print('Fout $err');
      return false;
    }
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
      var contentType = ContentType.getContentType(avatar);
      /* 
      String contentType;
      if (avatar.endsWith('jpeg') || avatar.endsWith('jpg')) {
        contentType = 'image/jpeg';
      } else if (avatar.endsWith('png')) {
        contentType = 'image/png';
      } else if (avatar.endsWith('gif')) {
        contentType = 'image/gif';
      } else {
        contentType = 'application/octet-stream';
      }
 */
      var _req =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/api/profile'));
      var file = await http.MultipartFile.fromPath('filename', avatar,
          contentType: MediaType.parse(contentType));
      _req.files.add(file);
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
