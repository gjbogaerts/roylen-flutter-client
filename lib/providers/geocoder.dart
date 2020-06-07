import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_key.dart';

class GeoCoder {
  static Future<Map> getCoordinatesFromPostCode(String code) async {
    var _apiKey = ApiKey.getGoogleGeoCodingKey();
    var _url =
        'https://maps.googleapis.com/maps/api/geocode/json?components=country:NL|postal_code:$code&key=$_apiKey';
    var _response = await http.get(_url);
    var _geocode = json.decode(_response.body);
    var _lat = _geocode['results'][0]['geometry']['location']['lat'] as double;
    var _lng = _geocode['results'][0]['geometry']['location']['lng'] as double;
    var codeToReturn = {'latitude': _lat, 'longitude': _lng};
    return codeToReturn;
  }
}
