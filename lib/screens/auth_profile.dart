import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:email_validator/email_validator.dart';
import '../widgets/app_drawer.dart';
import '../providers/auth.dart';
import '../models/user.dart';
import '../utils/server_interface.dart';

class AuthProfile extends StatefulWidget {
  static const routeName = '/auth-profile';
  @override
  _AuthProfileState createState() => _AuthProfileState();
}

class _AuthProfileState extends State<AuthProfile> {
  User _user;
  bool _isLoading = false;
  bool _isInit = true;
  var _baseUrl = ServerInterface.getBaseUrl();
  var _formKey = GlobalKey<FormState>();
  String _email;
  String _imageLocation;
  File _pic;
  Future<bool> _profileChangeAttemptResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _user = Provider.of<Auth>(context).getUser();
      if (_user != null) {
        setState(() {
          _isLoading = false;
        });
      }
      _isInit = false;
    }
  }

  void _pickPhoto(String source) async {
    File imageFile;
    if (source == 'camera') {
      imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    if (imageFile == null) {
      return;
    }
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final imageLocation = '${appDir.path}/$fileName';
    /* final savedImage =  */
    await imageFile.copy(imageLocation);
    _imageLocation = imageLocation;
    setState(() {
      _pic = imageFile;
    });
  }

  void _saveFormValues() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_email == null && _imageLocation == null) {
      return;
    }
    _profileChangeAttemptResult =
        Provider.of<Auth>(context).changeProfile(_imageLocation, _email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wijzig je profiel'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      _user.screenName,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                  _pic != null
                      ? Image.file(_pic,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover)
                      : _user.avatar == null
                          ? Image.asset(
                              'assets/images/image9.jpeg',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              _user.avatar.startsWith('http')
                                  ? _user.avatar
                                  : '$_baseUrl${_user.avatar}',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                              'Je schermnaam kan niet worden gewijzigd. Je kunt wel een andere profielfoto kiezen en je emailadres veranderen.'),
                        ),
                        FutureBuilder(
                            future: _profileChangeAttemptResult,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Center(
                                  child: Text(
                                      'Je profielwijziging is gelukt. Om je wijzingen te zien, moet je even uitloggen en weer opnieuw inloggen.'),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text(snapshot.error.toString()));
                              }
                              return Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        RaisedButton.icon(
                                          icon: Icon(Icons.photo_album),
                                          label: Text('Kies een foto'),
                                          color: Theme.of(context).hintColor,
                                          onPressed: () {
                                            _pickPhoto('gallery');
                                          },
                                        ),
                                        RaisedButton.icon(
                                          icon: Icon(Icons.photo_camera),
                                          label: Text('Maak een foto'),
                                          color: Theme.of(context).hintColor,
                                          onPressed: () {
                                            _pickPhoto('camera');
                                          },
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Nieuw emailadres'),
                                      initialValue: _user.email,
                                      validator: (val) {
                                        if (!EmailValidator.validate(
                                            val.trim())) {
                                          return 'Dit is geen geldig email-adres.';
                                        } else
                                          return null;
                                      },
                                      onSaved: (val) {
                                        _email = val.trim();
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        RaisedButton(
                                          onPressed: _saveFormValues,
                                          color: Theme.of(context).accentColor,
                                          child: Text('Bewaren'),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
