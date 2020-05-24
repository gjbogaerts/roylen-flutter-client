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
