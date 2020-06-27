import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import './my_image_picker.dart';
import './my_location_picker.dart';
import '../models/ad.dart';
import '../providers/ads.dart';
import '../providers/toaster.dart';
import '../utils/server_interface.dart';
import 'ad_age_category.dart';
import 'ad_categories.dart';

class AdForm extends StatefulWidget {
  final Function _saveCallback;
  final Ad ad;
  AdForm(this._saveCallback, {this.ad});
  @override
  _AdFormState createState() => _AdFormState();
}

class _AdFormState extends State<AdForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedMainCategory;
  String _selectedSubCategory;
  String _selectedSubSubCategory;
  String _selectedAgeCategory;
  bool _autoValidate = false;
  bool _hasError = false;
  String _errorString;
  String _baseUrl = ServerInterface.getBaseUrl();

  Map<String, dynamic> _formData = {
    'title': '',
    'description': '',
    'virtualPrice': 0,
    'mainCategory': '',
    'subCategory': '',
    'subSubCategory': '',
    'ageCategory': '0-16',
    'picture': [],
    'latitude': '',
    'longitude': ''
  };

  @override
  void initState() {
    super.initState();
    if (widget.ad != null) {
      _formData['title'] = widget.ad.title;
      _formData['description'] = widget.ad.description;
      _formData['virtualPrice'] = widget.ad.virtualPrice.toString();
      _formData['mainCategory'] = widget.ad.mainCategory;
      _formData['subCategory'] = widget.ad.subCategory;
      _formData['subSubCategory'] = widget.ad.subSubCategory;
      _formData['ageCategory'] = widget.ad.ageCategory;
      _formData['picture'] = widget.ad.pictureArray;
      _setAdAgeCategory(widget.ad.ageCategory);
      _setMainCat(widget.ad.mainCategory);
      _setSubCat(widget.ad.subCategory);
      _setSubSubCat(widget.ad.subSubCategory);
    }
  }

  void _setAdAgeCategory(String age) {
    _selectedAgeCategory = age;
  }

  void _setMainCat(String cat) {
    _selectedMainCategory = cat;
  }

  void _setSubCat(String cat) {
    _selectedSubCategory = cat;
  }

  void _setSubSubCat(String cat) {
    _selectedSubSubCategory = cat;
  }

  void _setLocationData(LocationData _loc) {
    _formData['latitude'] = _loc.latitude;
    _formData['longitude'] = _loc.longitude;
  }

  void _saveForm() {
    _formData['ageCategory'] = _selectedAgeCategory;
    _formData['mainCategory'] = _selectedMainCategory;
    _formData['subCategory'] = _selectedSubCategory;
    _formData['subSubCategory'] = _selectedSubSubCategory;
    if (!_formKey.currentState.validate()) {
      setState(() {
        _hasError = true;
        _errorString =
            'Het formulier is niet correct ingevuld. Check de fouten.';
        _autoValidate = true;
      });
      return;
    }
    var pics = _formData['picture'] as List;
    if (pics.length == 0) {
      setState(() {
        _hasError = true;
        _errorString = 'Je hebt nog geen foto gemaakt of gekozen.';
      });
      return;
    }
    _formKey.currentState.save();
    widget._saveCallback(_formData);
  }

  Future<void> _getPickedImages(
      List<Map<String, dynamic>> imagesDataList) async {
    _formData['picture'] = imagesDataList;
    await Provider.of<Ads>(context, listen: false)
        .adPicToAd(widget.ad.id, imagesDataList);
  }

  List<Widget> _getExistingImages() {
    return (_formData['picture'] as List)
        .map(
          (e) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Image.network(
                  '$_baseUrl$e',
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ),
                GestureDetector(
                  onTap: () async {
                    var success = await Provider.of<Ads>(context, listen: false)
                        .removePicFromAd(widget.ad.id, e);
                    if (success) {
                      setState(() {
                        _formData['picture'].remove(e);
                      });
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                    child: Icon(
                      Icons.delete,
                      color: Color(0x99FF0000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_hasError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<Toaster>(context, listen: false).setMessage(_errorString);
          return Provider.of<Toaster>(context, listen: false)
              .showSnackBar(context);
        });
      }
      return Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
          child: Column(
            children: <Widget>[
              MyImagePicker(
                _getPickedImages,
                maxPickedImages: 5 - _formData['picture'].length,
              ),
              Row(
                children: _getExistingImages(),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autocorrect: false,
                decoration: const InputDecoration(
                    hintText: 'Ten minste vijf tekens', labelText: 'Titel'),
                validator: (val) {
                  if (val.isEmpty || val.length < 5) {
                    return 'Titel moet ten minste vijf tekens lang zijn';
                  }
                  return null;
                },
                onSaved: (val) {
                  _formData['title'] = val;
                },
                initialValue: _formData['title'],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autocorrect: true,
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(
                    hintText: 'Ten minste dertig tekens',
                    labelText: 'Beschrijving'),
                validator: (val) {
                  if (val.isEmpty || val.length < 30) {
                    return 'Beschrijving moet ten minste dertig tekens lang zijn';
                  }
                  return null;
                },
                onSaved: (val) {
                  _formData['description'] = val;
                },
                initialValue: _formData['description'],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: _formData['virtualPrice'].toString(),
                decoration: const InputDecoration(
                    labelText: 'Prijs in nix',
                    hintText: 'Gebruik alleen gehele getallen'),
                validator: (val) {
                  if (val.isEmpty ||
                      int.tryParse(val) == null ||
                      int.tryParse(val) < 0 ||
                      int.tryParse(val) > 999) {
                    return 'Voer een prijs in tussen 0 en 1000 nix.';
                  }
                  return null;
                },
                onSaved: (val) {
                  _formData['virtualPrice'] = val;
                },
              ),
              SizedBox(
                height: 10,
              ),
              AdAgeCategory(
                _setAdAgeCategory,
                existingAgeCat: _formData['ageCategory'],
              ),
              SizedBox(height: 10),
              AdCategories(
                _setMainCat,
                _setSubCat,
                _setSubSubCat,
                existingMainCat:
                    widget.ad != null ? widget.ad.mainCategory : null,
                existingSubCat:
                    widget.ad != null ? widget.ad.subCategory : null,
                existingSubSubCat:
                    widget.ad != null ? widget.ad.subSubCategory : null,
              ),
              SizedBox(
                height: 10,
              ),
              MyLocationPicker(_setLocationData),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width / 2,
                height: 50,
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).accentColor,
                  onPressed: () {
                    _saveForm();
                  },
                  icon: Icon(Icons.save_alt),
                  label: Text('Bewaren'),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}
