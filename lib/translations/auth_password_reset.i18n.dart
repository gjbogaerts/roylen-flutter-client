import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("nl_nl") +
      {"nl_nl": "OK", "en_us": "OK"} +
      {"nl_nl": "Mislukt", "en_us": "Failure"} +
      {
        "nl_nl": "Excuus, er ging iets mis",
        "en_us": "Our apologies, something went wrong"
      } +
      {"nl_nl": "Gelukt", "en_us": "Success"} +
      {
        "nl_nl":
            "Je hebt een email gekregen met een code erin. Vul deze code hieronder in en maak een nieuw wachtwoord aan.",
        "en_us":
            "You have received an email containing a secret key. Please fill out this code underneath and create a new password."
      } +
      {
        "nl_nl": "Je kunt nu inloggen met je nieuwe wachtwoord",
        "en_us": "You can now log in with your new password"
      } +
      {"nl_nl": "Wachtwoord vergeten", "en_us": "Forgot password"} +
      {
        "nl_nl":
            "Vul hier eerst je emailadres in, en klik dan op verzenden. Je krijgt dan een code toegestuurd waarmee je hieronder een nieuw wachtwoord kunt aanmaken.",
        "en_us":
            "Please fill out your email address underneath, and click Send. You'll get a key in your mail that you can use to create a new password."
      } +
      {"nl_nl": "Je emailadres", "en_us": "Your email address"} +
      {
        "nl_nl": "Je moet een emailadres invullen",
        "en_us": "You have to fill out a valid email address"
      } +
      {"nl_nl": "Versturen", "en_us": "Send"} +
      {"nl_nl": "Verzenden", "en_us": "Send"} +
      {"nl_nl": "Je code", "en_us": "Your secre t key"} +
      {
        "nl_nl": "Je moet een code invullen",
        "en_us": "You have to fill out your secret key"
      } +
      {"nl_nl": "Je nieuwe wachtwoord", "en_us": "Your new password"} +
      {
        "nl_nl": "Je moet een wachtwoord invullen",
        "en_us": "You have to fill out a password"
      } +
      {
        "nl_nl": "Herhaal je wachtwoord",
        "en_us": "Please fill out your password again"
      } +
      {
        "nl_nl": "Je moet je wachtwoord nog een keer invullen",
        "en_us": "You have to fill out your password once more"
      } +
      {
        "nl_nl": "De wachtwoorden zijn niet gelijk.",
        "en_us": "The passwords are not equal"
      };
  String get i18n => localize(this, t);
}
