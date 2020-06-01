// import 'package:flutter/foundation.dart';

class Cats {
  static Set<Map<String, List<Map<String, List<String>>>>> _maincategories = {
    {
      'Decoratie': [
        {'Accessoires': []},
        {'Klokken': []},
        {'Gordijnen': []},
        {'Schilderijen en posters': []},
        {'Spaarpotten': []},
        {'Spiegels': []}
      ]
    },
    {
      'Kleding': [
        {
          'Accessoires': [
            'Handschoenen en wanten',
            'Mutsen',
            'Panty\'s en maillots',
            'Petten en hoeden',
            'Sjaals en dassen',
            'Spuugdoekjes'
          ]
        },
        {
          'Badmode': [
            'Bedekkende zwemkleding',
            'Bikini\s',
            'Zwembroeken',
            'Zwempakken'
          ]
        },
        {
          'Broeken': ['Korte broeken', 'Lange broeken']
        },
        {
          'Jassen': [
            'Bodywarmers',
            'Regenjassen',
            'Winterjassen',
            'Zomerjassen'
          ]
        },
        {
          'Ondergoed': ['Hemden', 'Onderbroeken', 'Topjes', 'Rompers']
        },
        {
          'Pyjama\'s': ['Pyjama\'s', 'Slaapzakjes']
        },
        {
          'Rokken en jurken': ['Jurken', 'Rokken']
        },
        {
          'Schoenen': [
            'Chique schoenen',
            'Gympen en sneakers',
            'Laarzen',
            'Sandalen en slippers',
            'Sportschoenen',
            'Outdoorschoenen'
          ]
        },
        {
          'Shirts': ['T-shirts met lange mouwen', 'T-shirts met korte mouwen']
        },
        {'Sokken': []},
        {'Sportkleding': []},
        {'Truien': []},
        {'Vesten': []}
      ]
    },
    {
      'Meubels': [
        {
          'Banken en stoelen': [
            'Banken',
            'Fauteuils',
            'Hoge kinderstoelen',
            'Lage kinderstoeltjes',
            'Krukken',
            'Poefs',
            'Schommelstoelen',
            'Wipstoeltjes',
            'Zitzakken',
            'Voedingskussens'
          ]
        },
        {
          'Bedden, wiegjes en toebehoren': [
            'Dekbedden en kussens',
            'Dekbedovertrekken, hoeslakens en slopen',
            'Lage bedden',
            'Lattenbodems',
            'Ledikantjes',
            'Hoogslapers',
            'Matrassen',
            'Stapelbedden',
            'Wiegjes'
          ]
        },
        {
          'Boxen': ['Boxen', 'Boxkleden']
        },
        {
          'Kasten': [
            'Boeken en dvd-kasten',
            'Commodes',
            'Ladenkasten',
            'Kledingkasten',
            'Open wandmeubels',
            'Speelgoedopbergers'
          ]
        },
        {
          'Tafels': [
            'Bureaus',
            'Lage tafels met stoeltjes',
            'Lage tafels zonder stoeltjes'
          ]
        },
        {
          'Verlichting': [
            'Bewegingsgevoelige lampen',
            'Bureaulampen',
            'Nachtlampjes',
            'Plafondlampen',
            'Sfeerverlichting',
            'Staande lampen',
            'Wandlampen'
          ]
        }
      ]
    },
    {
      'Onderweg': [
        {'Autostoeltjes': []},
        {'Buggy\s en kinderwagens': []},
        {'Draagzakken en -doeken': []},
        {
          'Fietsen': [
            'Bakfietsen',
            'Fietskarren',
            'Fietszitjes',
            'Kinderfietsen',
            'Mama- en papafietsen'
          ]
        },
        {'Maxicosi\'s': []},
        {
          'Tassen': ['Luiertassen', 'Rugzakjes']
        }
      ]
    },
    {
      'Speelgoed': [
        {'Actiefiguren': []},
        {'Autootjes en andere voertuigen': []},
        {
          'Beeld en geluid': [
            'Cd\'s',
            'Dvd\'s',
            'Blu-Ray',
            'Muziekinstrumenten'
          ]
        },
        {'Bellenblaas': []},
        {
          'Boeken': [
            'Boeken over zwangerschap, kinderen en ouderschap',
            'Informatieve kinderboeken',
            'Prentenboeken',
            'Leesboeken',
            'Stripboeken',
            'Leren lezen'
          ]
        },
        {
          'Bouwen': ['Blokken', 'Duplo', 'Kapla', 'Knex', 'Lego', 'Playmobil']
        },
        {
          'Buiten spelen': [
            'Balspellen',
            'Klimrekken',
            'Loopfietsjes en -wagens',
            'Huisjes en tenten',
            'Rolschaatsen, skeelers en skateboards',
            'Schommels',
            'Skippyballen',
            'Springtouwen',
            'Stelten en klossen',
            'Steppen',
            'Stoepkrijt',
            'Trampolines en springkussens',
            'Waterspeelgoed',
            'Zandbakspeelgoed',
            'Zwembadjes'
          ]
        },
        {
          'Digitaal speelgoed': [
            'Camera\'s',
            'Drones',
            'Games',
            'Laptops en desktops',
            'Robots',
            'Spelcomputers',
            'Tablets',
            'Walkietalkies'
          ]
        },
        {'Gezelschapsspelletjes': []},
        {'Jojo\'s, tollen en diabolo\'s': []},
        {
          'Knikkers': ['Knikkerbanen', 'Knikkers']
        },
        {'Knuffels': []},
        {
          'Knutselspullen': [
            'Knippen en plakken',
            'Schrijven',
            'Tekenen en kleuren',
            'Verven'
          ]
        },
        {
          'Poppen': ['Barbies', 'Poppen', 'Poppenhuizen', 'Poppenspulletjes']
        },
        {'Puzzels': []},
        {'Verkleedkleren, maskers en pruiken': []}
      ]
    },
    {
      'Veiligheid': [
        {'Anti-slip': []},
        {'Babyfoons en monitors': []},
        {'Deur- en raambeveiliging': []},
        {'Hoekbescherming': []},
        {'Kast- en ladebeveiliging': []},
        {'Opstapjes': []},
        {'Stopcontactbeveiliging': []},
        {'Traphekjes': []}
      ]
    },
    {
      'Verzorging': [
        {'Badjes': []},
        {
          'Badtextiel': ['Badjassen', 'Handdoeken']
        },
        {
          'Eten en drinken': [
            'Bestek',
            'Broodtrommels',
            'Drinkbekers, -flessen en thermoskannen',
            'Servies',
            'Slabbetjes',
            'Tuit en anti-morsbekers',
            'Flesjes',
            'Flessenwarmers',
            'Kolven',
            'Speentjes'
          ]
        },
        {'Kruiken': []},
        {
          'Verzorgingsproducten': ['Haarverzorging', 'Lichaamsverzorging']
        },
        {
          'WC en zindelijkheid': [
            'Brilverkleiners',
            'Hydrofiele luiers',
            'Potjes',
            'Wegwerpluiers',
            'Zwemluiers'
          ]
        }
      ]
    }
  };

  static Set<Map<String, List<Map<String, List<String>>>>> get categories {
    return _maincategories;
  }

  static List<String> get mainCategoriesOnly {
    List<String> _mains = [];
    _maincategories.forEach((element) {
      element.keys.forEach((e) {
        _mains.add(e);
      });
    });
    _mains.sort();
    return _mains;
  }

  static List<String> getSubCategories(String _mainCat) {
    if (_mainCat == null) {
      return [];
    }
    List<String> _subs = [];
    var _tmp = {..._maincategories};
    _tmp.retainWhere((element) => element.containsKey(_mainCat));
    _tmp.forEach((elm) {
      elm.forEach((key, value) {
        value.forEach((e) {
          e.keys.forEach((e2) {
            _subs.add(e2);
          });
        });
      });
    });
    _subs.sort();
    return _subs;
  }

  static List<String> getSubSubCategories(String _mainCat, String _subCat) {
    if (_mainCat == null || _subCat == null) {
      return [];
    }
    List<String> _subSubs = [];
    var _tmpMain = {..._maincategories};
    _tmpMain.retainWhere((element) => element.containsKey(_mainCat));
    var _tmpSub = _tmpMain.first[_mainCat];
    _tmpSub.forEach((element) {
      if (element.containsKey(_subCat)) {
        if (element[_subCat].length > 0) {
          element[_subCat].forEach((element) {
            _subSubs.add(element);
          });
        }
      }
    });
    return _subSubs;
  }
}
