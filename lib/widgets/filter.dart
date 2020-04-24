import 'package:flutter/material.dart';

import '../models/categories.dart';

///
///gevraagd/aangeboden
///categorie
///prijs
///afstand
///
///
///

enum AdNature { offered, wanted }

class Filter extends StatefulWidget {
  final Function filterCallback;
  Filter(this.filterCallback);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  var _filterElements = {
    'category': '',
    'priceMin': 0,
    'priceMax': 250,
    'maxDistance': 200.0,
    'adNature': null
  };

  AdNature _adNature = AdNature.offered;
  var _formKey = GlobalKey<FormState>();

  void setSearch() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    _filterElements['adNature'] = _adNature;
    widget.filterCallback(_filterElements);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField(
                        decoration: const InputDecoration(
                            labelText: 'Kies je categorie'),
                        onChanged: (val) {
                          setState(() {
                            _filterElements['category'] = val;
                          });
                        },
                        items: Categories.categories,
                        onSaved: (val) {
                          _filterElements['category'] = val;
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Minimum prijs'),
                            validator: (val) {
                              if (val.isEmpty ||
                                  int.tryParse(val) == null ||
                                  int.parse(val) < 0) {
                                return 'Vul een positief getal in.';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _filterElements['priceMin'] = val;
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Maximum prijs'),
                            validator: (val) {
                              if (val.isEmpty || int.tryParse(val) == null) {
                                return 'Vul een maximum prijs in, in gehele getallen';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _filterElements['priceMax'] = val;
                            },
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: RadioListTile(
                              title: const Text('Aangeboden'),
                              groupValue: _adNature,
                              value: AdNature.offered,
                              onChanged: (AdNature value) {
                                setState(() {
                                  _adNature = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: RadioListTile(
                              title: const Text('Gezocht'),
                              groupValue: _adNature,
                              value: AdNature.wanted,
                              onChanged: (AdNature value) {
                                setState(() {
                                  _adNature = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Maximale afstand:',
                              style: TextStyle(
                                  color: Theme.of(context).hintColor)),
                          Slider(
                              activeColor: Theme.of(context).accentColor,
                              label: '${_filterElements['maxDistance']} km',
                              value: _filterElements['maxDistance'],
                              onChanged: (val) {
                                setState(() {
                                  _filterElements['maxDistance'] = val;
                                });
                              },
                              divisions: 13,
                              min: 5,
                              max: 200),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                            color: Theme.of(context).canvasColor,
                            textColor: Theme.of(context).primaryColor,
                            child: Text('Laat maar zitten'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColor,
                            child: Text('Pas filter toe'),
                            onPressed: () {
                              setSearch();
                            })
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
