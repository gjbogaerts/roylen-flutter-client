import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("nl_nl") +
      {"nl_nl": "Antwoord", "en_us": "Answer"} +
      {"nl_nl": "Verzenden", "en_us": "Send"} +
      {"nl_nl": "Annuleren", "en_us": "Cancel"} +
      {
        "nl_nl": "Verberg de gelezen berichten",
        "en_us": "Hide the messages you've already seen"
      } +
      {"nl_nl": "Markeer als ongelezen", "en_us": "Mark unread"} +
      {"nl_nl": "Markeer als gelezen", "en_us": "Mark read"} +
      {
        "nl_nl": "Toon de gelezen berichten",
        "en_us": "Show the messages you've already seen"
      } +
      {"nl_nl": "Je boodschappen", "en_us": "Your messages"} +
      {
        "nl_nl": "Nog geen boodschappen voor je",
        "en_us": "You have no messages yet"
      } +
      {"nl_nl": "Type hier je boodschap", "en_us": "Enter your message"} +
      {
        "nl_nl": "Je boodschap is verstuurd.",
        "en_us": "Your message has been sent"
      } +
      {"nl_nl": "OK", "en_us": "OK"};
  String get i18n => localize(this, t);
}
