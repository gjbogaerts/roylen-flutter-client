import './user.dart';

class Offer {
  String id;
  final String adId;
  String adTitle;
  String adPic;
  String adCreatorId;
  final User fromUser;

  final int amount;
  final String dateAdded;
  var accepted;
  var closed;

  Offer(
      {this.id = '',
      this.adTitle = '',
      this.adPic = '',
      this.adCreatorId = '',
      this.adId,
      this.fromUser,
      this.amount,
      this.dateAdded,
      this.accepted = false,
      this.closed = false});

  factory Offer.fromJson(Map<String, dynamic> json) {
    var _adId = '';
    var _adTitle = '';
    var _adPic = '';
    var _adCreator = '';
    if (json['ad'] is Map) {
      Map _adMap = json['ad'];
      _adId = _adMap['_id'];
      _adTitle = _adMap['title'];
      _adPic = _adMap['pics'][0];
      _adCreator = _adMap['creator'];
    } else {
      _adId = json['ad'];
    }
    return Offer(
        id: json['_id'],
        adId: _adId,
        adTitle: _adTitle,
        adPic: _adPic,
        adCreatorId: _adCreator,
        fromUser: User.fromJson(json['fromUser']),
        amount: json['amountOffered'],
        dateAdded: json['dateAdded'],
        accepted: json['accepted'],
        closed: json['closed']);
  }
}
