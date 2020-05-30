import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../models/categories.dart';

enum AdNature { offered, wanted }

class AdForm extends StatefulWidget {
  final Function _saveCallback;

  AdForm(this._saveCallback);
  @override
  _AdFormState createState() => _AdFormState();
}

class _AdFormState extends State<AdForm> {
  final _formKey = GlobalKey<FormState>();
  AdNature _adNature = AdNature.offered;
  String _selectedCategory;
  File _selectedImage;
/*   bool _hasError = false;
  String _errorString; */

  var _formData = {
    'title': '',
    'description': '',
    'category': '',
    'virtualPrice': 0,
    'adNature': 'offered',
    'picture': '',
    'location': '',
  };

  @override
  void initState() {
    _selectedCategory = Categories.categories.first.value;
    super.initState();
  }

  void _saveForm() {
    if (!_formKey.currentState.validate()) {
/*       setState(() {
        _hasError = true;
        _errorString =
            'Het formulier is niet correct ingevuld. Check de fouten.';
      }); */
      return;
    }
    if (_formData['picture'] == '') {
/*       setState(() {
        _hasError = true;
        _errorString = 'Je hebt nog geen foto gemaakt of gekozen.';
      }); */
      return;
    }
    _formKey.currentState.save();
    _formData['adNature'] =
        _adNature == AdNature.offered ? 'offered' : 'wanted';
    widget._saveCallback(_formData);
  }

  Future<void> _getImage(String source) async {
    File _imageFile;
    PickedFile _pickedFile;
    var _picker = ImagePicker();
    if (source == 'camera') {
      _pickedFile = await _picker.getImage(source: ImageSource.camera);
    } else {
      _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    }
    if (_pickedFile == null) {
      return;
    }
    _imageFile = File(_pickedFile.path);
    setState(() {
      _selectedImage = _imageFile;
    });
    // print(imageFile);

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(_imageFile.path);
    final imageLocation = '${appDir.path}/$fileName';
    /* final savedImage =  */
    await _imageFile.copy(imageLocation);
    _formData['picture'] = imageLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton.icon(
                  color: Theme.of(context).canvasColor,
                  onPressed: () {
                    _getImage('camera');
                  },
                  icon: Icon(Icons.photo_camera),
                  label: Text('Neem een foto'),
                ),
                RaisedButton.icon(
                  color: Theme.of(context).canvasColor,
                  onPressed: () {
                    _getImage('gallery');
                  },
                  icon: Icon(Icons.photo_album),
                  label: Text('Kies een foto'),
                )
              ],
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
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
                value: _selectedCategory,
                decoration: InputDecoration(
                    labelText: 'Kies je categorie',
                    labelStyle: Theme.of(context).textTheme.bodyText1),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });

                  _formData['category'] = val;
                },
                items: Categories.categories,
                onSaved: (val) {
                  _formData['category'] = val;
                }),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
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
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ListTile(
                        dense: true,
                        title: Text('Aangeboden',
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodyText1),
                        trailing: Radio(
                          groupValue: _adNature,
                          focusColor: Theme.of(context).primaryColor,
                          hoverColor: Theme.of(context).primaryColor,
                          activeColor: Theme.of(context).primaryColor,
                          value: AdNature.offered,
                          onChanged: (AdNature value) {
                            setState(() {
                              _adNature = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Gezocht',
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodyText1),
                        dense: true,
                        trailing: Radio(
                          groupValue: _adNature,
                          activeColor: Theme.of(context).primaryColor,
                          focusColor: Theme.of(context).primaryColor,
                          hoverColor: Theme.of(context).primaryColor,
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
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _selectedImage != null
                ? Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Image.file(
                      _selectedImage,
                      height: 200,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                : SizedBox(height: 0),
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
  }
}
