import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/server_interface.dart';
import '../models/user.dart';

class Auth with ChangeNotifier {
  final String baseUrl = ServerInterface.getBaseUrl();
  String _token;
  String _userId;
  String _email;
  String _screenName;
  int _nix;
  String _avatar;

  bool _isAuth() {
    return _token != null;
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
        headers: {'content-type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      var _userData = json.decode(uriResponse.body);
      _token = _userData['token'];
      _email = _userData['email'];
      _screenName = _userData['screenName'];
      _userId = _userData['_id'];
      _avatar = _userData['avatar'];
      _nix = _userData['nix'];
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token);
      prefs.setString('email', _email);
      prefs.setString('avatar', _avatar);
      prefs.setString('userId', _userId);
      prefs.setString('screenName', _screenName);
      notifyListeners();
      return true;
    } catch (err) {
      print(err);
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
          headers: {'content-type': 'application/json'},
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

      var _req =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/api/profile'));
      var file = await http.MultipartFile.fromPath('filename', avatar,
          contentType: MediaType.parse(contentType));
      _req.files.add(file);
      _req.headers.putIfAbsent('Authorization', () => 'Bearer $_token');
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
      prefs.setString('userId', _userData['id']);
      prefs.setString('screenName', _userData['screenName']);
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
