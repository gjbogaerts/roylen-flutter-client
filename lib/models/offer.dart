import './user.dart';

class Offer {
  String id;
  final String adId;
  final User fromUser;
  final int amount;
  final String dateAdded;

  Offer({this.id = '', this.adId, this.fromUser, this.amount, this.dateAdded});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['_id'],
      adId: json['ad'],
      fromUser: User.fromJson(json['fromUser']),
      amount: json['amountOffered'],
      dateAdded: json['dateAdded'],
    );
  }
}
