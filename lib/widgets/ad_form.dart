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
    File imageFile;
    if (source == 'camera') {
      imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    print(imageFile);
    if (imageFile == null) {
      return;
    }
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final imageLocation = '${appDir.path}/$fileName';
    /* final savedImage =  */
    await imageFile.copy(imageLocation);
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
            ButtonBar(
              buttonPadding: EdgeInsets.symmetric(horizontal: 5),
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () {
                    _getImage('camera');
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Neem een foto'),
                ),
                RaisedButton.icon(
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
                decoration:
                    const InputDecoration(labelText: 'Kies je categorie'),
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
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Prijs in nix',
                        hintText: 'Gebruik alleen gehele getallen'),
                    validator: (val) {
                      if (val.isEmpty ||
                          int.tryParse(val) == null ||
                          int.tryParse(val) < 0) {
                        return 'Voer een prijs in, in positieve gehele getallen.';
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ListTile(
                          dense: true,
                          title: const Text('Aangeboden'),
                          trailing: Radio(
                            groupValue: _adNature,
                            value: AdNature.offered,
                            onChanged: (AdNature value) {
                              setState(() {
                                _adNature = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Gezocht'),
                          dense: true,
                          trailing: Radio(
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
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  /* if (_hasError) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(_errorString),
                    ));
                  } */
                  _saveForm();
                },
                icon: Icon(Icons.save_alt),
                label:
                    Text('Bewaren', style: Theme.of(context).textTheme.body2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}