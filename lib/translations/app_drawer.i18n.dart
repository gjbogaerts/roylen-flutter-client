import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var t = Translations("nl_nl") +
      {"nl_nl": "Meer opties:", "en_us": "More options:"} +
      {"nl_nl": "Advertentie overzicht", "en_us": "Ads List"} +
      {
        "nl_nl": "Alle advertenties, ongefilterd.",
        "en_us": "All ads, unfiltered."
      } +
      {"nl_nl": "Inloggen/registreren", "en_us": "Log in or Register"} +
      {"nl_nl": "Uitloggen", "en_us": "Log out"} +
      {"nl_nl": "Je profiel", "en_us": "Your profile"} +
      {
        "nl_nl": "Wijzig je email of je avatar.",
        "en_us": "Change your email or avatar."
      } +
      {"nl_nl": "Je boodschappen", "en_us": "Your messages"} +
      {"nl_nl": "Jouw advertenties", "en_us": "Your ads"} +
      {
        "nl_nl": "Bewerk of verwijder je eigen advertenties.",
        "en_us": "Edit or remove your ads."
      } +
      {"nl_nl": "Over Roylen", "en_us": "About Roylen"} +
      {
        "nl_nl": "Contact, privacy, info en wat dies meer zij.",
        "en_us": "Contact info, your privacy and other interesting tidbits."
      } +
      {
        "nl_nl":
            "Lees je boodschappen van andere gebruikers, en beantwoord ze hier.",
        "en_us": "Read messages from other users, and answer them here."
      };

  String get i18n => localize(this, t);
}
