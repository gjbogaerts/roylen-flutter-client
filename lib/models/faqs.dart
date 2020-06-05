class Faq {
  final String headerValue;
  final String expandedValue;
  bool isExpanded;
  Faq({this.headerValue, this.expandedValue, this.isExpanded = false});
}

class Faqs {
  static final List<Faq> _faqs = [
    Faq(
        headerValue: 'Over Roylen',
        expandedValue:
            'Zonder winstoogmerk. Gemaakt uit liefde voor de planeet en zijn inwoners, in het bijzonder voor alle jonge ouders die zich vertwijfeld afvragen of hun kind elke drie maanden nieuwe kleren en nieuw speelgoed nodig blijft hebben. Voor altijd gratis in het basisgebruik, met volledige garantie op privacy van jou, als eindgebruiker. (zie ons privacystatement).\n\nNiet bedoeld om zoveel mogelijk clicks te genereren of je zo lang mogelijk in deze app te houden, maar om je leven net een klein beetje eenvoudiger te maken, je wat geld te besparen, en in de tussentijd ook nog iets goeds te doen voor de planeet.\n\nBen je er blij mee? Spread the word. Je kunt ook een review achterlaten in de App Store. En als je op of aanmerkingen hebt? Gebruik het contactformulier hierboven.'),
    Faq(
      headerValue: 'Wat is Roylen? En nix? Hoezo nix?',
      expandedValue:
          'Roylen? Het is oud-Nederlands voor ruilen. (Zie http://www.etymologiebank.nl/trefwoord/ruilen).\n\nNix zijn de interne munteenheid van Roylen. Als je je inschrijft, krijg je 100 nix, zomaar, gratis en voor niks. Als je een product te ruilen aanbiedt, kun je er een waarde op plakken. Zo kun je meer nix verzamelen; en die kun je dan weer gebruiken om producten van anderen over te nemen. Zo kan de ruilwaarde van de dingen worden uitgedrukt in nix.',
    ),
    Faq(
      headerValue: 'Je privacy',
      expandedValue:
          'Je locatie is alleen maar nodig om vast te leggen welke advertenties voor jou het meest van belang zijn. We filteren op afstand. Deze gegevens, en alle andere gegevens die we over jou verzamelen, worden enkel en alleen gebruikt om de app goed te laten functioneren. Wij hebben verder geen enkel financieel belang bij deze gegevens; je kunt de app anoniem gebruiken om door de advertenties te bladeren, maar als je wat van de andere functies wil proberen, moet je een account aanmaken.\n\nDat kan anoniem; het enige wat je van je nodig hebben, is een email adres. Dat wordt verwijderd als je je account verwijdert, en wordt voor geen enkel ander doel gebruikt dan je af en toe te kunnen berichten als een andere gebruiker contact met je zoekt of als er belangrijke systeem-informatie is.',
    ),
    Faq(
      headerValue: 'Leveringsvoorwaarden',
      expandedValue:
          'De app is zorgvuldig en en met liefde voor detail opgebouwd, maar het is en blijft mensenwerk. We kunnen niet garanderen dat er nooit of te nimmer een bug of fout optreedt. Daarom kun je geen rechten ontlenen aan deze app of de daarin gepresenteerde informatie. Door deze app te downloaden en te gebruiken accepteer je deze leveringsvoorwaarden.\n\nVerder geldt een algemene waarschuwing: wees voorzichtig met de contacten die je via deze app opdoet. Omdat mensen anoniem kunnen zijn, is het verstandig om op je hoede te zijn als je afspraken gaat maken.',
    ),
    Faq(
        headerValue: 'PublicSpaces',
        expandedValue:
            'PublicSpaces is een organisatie die zich ten doel stelt om het publieke domein op het internet te versterken. Deze app is gemaakt met de waarborgen van PublicSpaces in het achterhoofd. Volledige transparantie is daarbij belangrijk. De broncode van  deze app is daarom openbaar, en kun je hier downloaden en inzien.\nClient: https://github.com/gjbogaerts/roylen-flutter-client \nServer API: https://github.com/gjbogaerts/roylen-react-server'),
    Faq(
        headerValue: 'Credits',
        expandedValue:
            'Design: Mirre Bogaerts\nIdee en ontwikkeling: GJ Bogaerts\n\nGebruik van open source instrumenten en bibliotheken:\nReact\nNode\nExpress\nFlutter\nMongo\nGit\nGithub\nVisual Studio Code.')
  ];
  static List<Faq> get faqs {
    return [..._faqs];
  }
}
