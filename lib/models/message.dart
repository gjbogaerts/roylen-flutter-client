import './creator.dart';

class Message {
  final String id;
  final String adId;
  final String adTitle;
  final Creator creator;
  final String message;
  bool isRead;
  final String dateSent;

  Message(
      {this.id,
      this.adId,
      this.adTitle,
      this.creator,
      this.message,
      this.isRead,
      this.dateSent});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['_id'],
        adId: json['adId'],
        adTitle: json['adTitle'],
        creator: Creator.fromJson(json['fromId']),
        message: json['message'],
        isRead: json['isRead'],
        dateSent: json['dateSent']);
  }
}
