import 'package:flutter/material.dart';
import '../models/categories.dart';
import 'package:location/location.dart';

enum AdNature { offered, wanted }

class Filter extends StatefulWidget {
  final Function filterCallback;
  Filter(this.filterCallback);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  Map<String, dynamic> _filterElements = {
    'category': null,
    'priceMin': null,
    'priceMax': null,
    'maxDistance': null,
    'adNature': null,
    'latitude': null,
    'longitude': null,
  };
  AdNature _adNature = AdNature.offered;
  var _formKey = GlobalKey<FormState>();
  Location _location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String _categorySelected;

  @override
  void initState() {
    _categorySelected = Categories.categories.first.value;
    super.initState();
  }

  void setSearch() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    _filterElements['adNature'] =
        _adNature == AdNature.offered ? 'offered' : 'wanted';
    widget.filterCallback(_filterElements);
    Navigator.of(context).pop();
  }

  void _startLocationCheck() {
    _checkLocationPermissions();
  }

  Future<void> _checkLocationPermissions() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await _location.getLocation();
    // print(_locationData);
    _filterElements['latitude'] = _locationData.latitude;
    _filterElements['longitude'] = _locationData.longitude;
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
                        value: _categorySelected,
                        decoration: const InputDecoration(
                            labelText: 'Kies je categorie'),
                        onChanged: (val) {
                          setState(() {
                            _filterElements['category'] = val;
                            setState(() {
                              _categorySelected = val;
                            });
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
                              value: _filterElements['maxDistance'] == null
                                  ? 200
                                  : _filterElements['maxDistance'],
                              onChangeStart: (_) => _startLocationCheck(),
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
