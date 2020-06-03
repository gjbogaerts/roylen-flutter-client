import 'package:flutter/material.dart';
import 'package:location/location.dart';
import './ad_categories.dart';
import 'ad_age_category.dart';

class Filter extends StatefulWidget {
  final Function filterCallback;
  Filter(this.filterCallback);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  Map<String, dynamic> _filterElements = {
    'mainCategory': null,
    'subCategory': null,
    'subSubCategory': null,
    'ageCategory': null,
    'priceMin': null,
    'priceMax': null,
    'maxDistance': null,
    'latitude': null,
    'longitude': null,
  };
  var _formKey = GlobalKey<FormState>();
  Location _location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState() {
    // _categorySelected = Categories.categories.first.value;
    super.initState();
  }

  void _setMainCats(String _mainCat) {
    _filterElements['mainCategory'] = _mainCat;
  }

  void _setSubCats(String _subCat) {
    _filterElements['subCategory'] = _subCat;
  }

  void _setSubSubCats(String _subSubCat) {
    _filterElements['subSubCategory'] = _subSubCat;
  }

  void _setAgeCat(String _ageCat) {
    _filterElements['ageCategory'] = _ageCat;
  }

  void setSearch() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    // print(_filterElements);

    _formKey.currentState.save();
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
                    AdCategories(_setMainCats, _setSubCats, _setSubSubCats),
                    AdAgeCategory(_setAgeCat),
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
