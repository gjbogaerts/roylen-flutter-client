import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/auth.dart' as AuthProvider;
import '../providers/toaster.dart';
import './auth_password_reset.dart';
import '../widgets/background.dart';

class Auth extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();
  final _pwController = TextEditingController();
  bool _hasError = false;
  bool _autoValidate = false;
  String _errorString;
  File _image;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'screenName': '',
    'avatar': ''
  };

  void _handlePasswordForgotten() {
    Navigator.of(context).pushNamed(AuthPasswordReset.routeName);
  }

  void handleLogin() async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _hasError = true;
        _autoValidate = true;
        _errorString =
            'Het formulier is niet correct ingevuld. Check de fouten.';
      });
      return;
    }
    var toaster = Provider.of<Toaster>(context, listen: false);
    _formKey.currentState.save();
    try {
      var _registerLogin =
          await Provider.of<AuthProvider.Auth>(context, listen: false)
              .loginUser(
                  email: _authData['email'], password: _authData['password']);
      if (_registerLogin) {
        toaster.setMessage('Je bent succesvol ingelogd.');
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        setState(() {
          _hasError = true;
          _errorString =
              'Er ging iets mis tijdens het inloggen. Probeer het alstublieft opnieuw.';
        });
      }
    } catch (err) {
      setState(() {
        _hasError = true;
        _errorString = err.toString();
      });
    }
  }

  void handleRegister() async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autoValidate = true;
        _hasError = true;
        _errorString =
            'Het formulier is niet correct ingevuld. Check de fouten.';
      });
      return;
    }
    var toaster = Provider.of<Toaster>(context, listen: false);
    _formKey.currentState.save();
    try {
      var _registerResult =
          await Provider.of<AuthProvider.Auth>(context, listen: false)
              .registerUser(
        avatar: _authData['avatar'],
        email: _authData['email'],
        screenName: _authData['screenName'],
        password: _authData['password'],
      );
      if (!_registerResult) {
        setState(() {
          _hasError = true;
          _errorString =
              'Er ging iets mis tijdens de registratie. Probeer het alstublieft opnieuw.';
        });
      } else {
        toaster.setMessage('Je bent succesvol geregistreerd en ingelogd.');
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (err) {
      setState(() {
        _hasError = true;
        _errorString = err.toString();
      });
    }
  }

  Future<void> getImage(String source) async {
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
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(_imageFile.path);
    final imageLocation = '${appDir.path}/$fileName';
    /* final savedImage =  */
    await _imageFile.copy(imageLocation);
    _authData['avatar'] = imageLocation;
    setState(() {
      _image = _imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _isRegistering = (ModalRoute.of(context).settings.arguments
        as Map<String, bool>)['registering'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Gebruikers'),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          Background(),
          SingleChildScrollView(
            child: Builder(
              builder: (BuildContext context) {
                return Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _isRegistering ? 'Registreren' : 'Inloggen',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Center(
                      child: CircleAvatar(
                        foregroundColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 50,
                        backgroundImage: _image == null
                            ? AssetImage('assets/images/image2.png')
                            : FileImage(_image),
                      ),
                    ),
                    Form(
                      autovalidate: _autoValidate,
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Je email-adres',
                                labelText: 'Email',
                              ),
                              validator: (val) {
                                if (!EmailValidator.validate(val.trim())) {
                                  return 'Dit is geen geldig email-adres.';
                                } else
                                  return null;
                              },
                              onSaved: (val) {
                                _authData['email'] = val.trim();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              autocorrect: false,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              controller: _pwController,
                              decoration: const InputDecoration(
                                hintText: 'Ten minste 5 tekens',
                                labelText: 'Wachtwoord',
                              ),
                              validator: (val) {
                                if (val.length < 5) {
                                  return 'Je wachtwoord moet ten minste vijf tekens lang zijn.';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                _authData['password'] = val;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_isRegistering)
                              Column(
                                children: <Widget>[
                                  TextFormField(
                                    autocorrect: false,
                                    obscureText: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: const InputDecoration(
                                      hintText: 'Je wachtwoord',
                                      labelText: 'Herhaal je wachtwoord',
                                    ),
                                    validator: (val) {
                                      if (val != _pwController.text) {
                                        return 'Je wachtwoorden komen niet overeen.';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    autocorrect: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Je schermnaam',
                                      hintText: 'Ten minste drie tekens',
                                    ),
                                    validator: (val) {
                                      if (val.isEmpty || val.length < 3) {
                                        return 'Je schermnaam moet ten minste drie tekens lang zijn.';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (val) {
                                      _authData['screenName'] = val;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () {
                                          getImage('camera');
                                        },
                                        color: Theme.of(context).canvasColor,
                                        child: Text('Maak een foto'),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          getImage('gallery');
                                        },
                                        color: Theme.of(context).canvasColor,
                                        child: Text('Kies een foto'),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // hier wachtwoord vergeten widget
                                if (!_isRegistering)
                                  GestureDetector(
                                    onTap: _handlePasswordForgotten,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Center(
                                          child: Text('Wachtwoord vergeten?')),
                                    ),
                                  ),
                                ButtonTheme(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 3,
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: RaisedButton(
                                    onPressed: _isRegistering
                                        ? () {
                                            handleRegister();
                                            if (_hasError)
                                              Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _errorString,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                          }
                                        : () {
                                            handleLogin();
                                            if (_hasError)
                                              Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _errorString,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                          },
                                    color: Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).accentColor,
                                    child: Text(
                                      _isRegistering
                                          ? 'Registreren'
                                          : 'Inloggen',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              Auth.routeName,
                              arguments: {'registering': !_isRegistering});
                        },
                        textColor: Theme.of(context).primaryColor,
                        child: Text(_isRegistering
                            ? 'Al een account? Je kunt hier inloggen'
                            : 'Nog geen account? Je kunt hier registreren'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
