import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/server_interface.dart';
import '../utils/api_key.dart';
import '../models/ad.dart';
import '../models/user.dart';
import '../models/offer.dart';

class Offers with ChangeNotifier {
  final String _baseUrl = ServerInterface.getBaseUrl();
  final String _apiKey = ApiKey.getKey();

  User forUser;
  List<Offer> offers;

  Error _err;

  Offers(this.forUser, this.offers);

  Error get err {
    return _err;
  }

  List<Offer> get items {
    return [...offers];
  }

  Future<bool> finalizeTransaction(
      String offerId, String from, String to, int amount) async {
    var _url = '$_baseUrl/api/offers/finalizetransaction';
    try {
      var _response = await http.post(_url,
          headers: {
            'content-type': 'application/json',
            'x-api-key': _apiKey,
            'Authorization': 'Bearer ${forUser.token}'
          },
          body: json.encode(
              {'offerId': offerId, 'from': from, 'to': to, 'amount': amount}));
      if (_response.statusCode != 200) {
        throw Exception(json.decode(_response.body));
      }
      notifyListeners();
      return true;
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<bool> acceptOffer(Offer offer, String adTitle) async {
    var _url = '$_baseUrl/api/offers/accept';
    try {
      var _response = await http.post(
        _url,
        headers: {
          'content-type': 'application/json',
          'x-api-key': _apiKey,
          'Authorization': 'Bearer ${forUser.token}'
        },
        body: json.encode({
          'offerId': offer.id,
          'fromUserId': offer.fromUser.id,
          'fromUserEmail': offer.fromUser.email,
          'adTitle': adTitle
        }),
      );
      if (_response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
        throw Exception(json.decode(_response.body));
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<List<Offer>> getOffersFromUser() async {
    var _url = '$_baseUrl/api/offers/fromUser';
    try {
      var _response = await http.get(_url, headers: {
        'content-type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer ${forUser.token}'
      });
      if (_response.statusCode != 200) {
        print('fout van server');
        throw Exception(json.encode(_response.body));
      }
      var _loadedData = List<Offer>();
      var _responseData = json.decode(_response.body) as List<dynamic>;
      // print(_responseData);
      _responseData.forEach((element) {
        _loadedData.add(Offer.fromJson(element));
      });
      // print(_loadedData);
      return _loadedData;
    } catch (err) {
      print(err);
      throw Exception(err);
    }
  }

  Future<void> setOffer({Ad ad, User fromUser, int offerAmount}) async {
    var _url = '$_baseUrl/api/offers/new';
    var _offer = Offer(
        adId: ad.id,
        amount: offerAmount,
        fromUser: fromUser,
        dateAdded: DateTime.now().toString());
    try {
      var _response = await http.post(_url,
          headers: {
            'content-type': 'application/json',
            'x-api-key': _apiKey,
            'Authorization': 'Bearer ${forUser.token}'
          },
          body: json.encode(
              {'adId': ad.id, 'userId': fromUser.id, 'amount': offerAmount}));
      if (_response.statusCode == 200) {
        offers.add(_offer);
        notifyListeners();
      } else {
        throw Exception('No favorable response from server');
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
