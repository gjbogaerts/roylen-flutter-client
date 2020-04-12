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

class Auth extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();
  final _pwController = TextEditingController();
  bool _registerSuccess = false;
  bool _loginSucces = false;
  bool _isInitRegister = true;
  File _image;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'screenName': '',
    'avatar': ''
  };

  void handleLogin() async {
    if (!_formKey.currentState.validate()) {
      print('not validated');
      return;
    }
    _formKey.currentState.save();
    try {
      var _registerLogin = await Provider.of<AuthProvider.Auth>(context)
          .loginUser(
              email: _authData['email'], password: _authData['password']);
      if (_registerLogin) {
        setState(() {
          _loginSucces = true;
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  void handleAuth() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      var _registerResult =
          await Provider.of<AuthProvider.Auth>(context).registerUser(
        avatar: _authData['avatar'],
        email: _authData['email'],
        screenName: _authData['screenName'],
        password: _authData['password'],
      );
      setState(() {
        _isInitRegister = false;
        _registerSuccess = _registerResult;
      });
    } catch (err) {
      print(err.toString());
    }
    // print(_authData);
  }

  Future<void> getImage(String source) async {
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
    _authData['avatar'] = imageLocation;
    setState(() {
      _image = imageFile;
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
      body: _loginSucces
          ? Center(
              child: Text('Succesvol ingelogd'),
            )
          : SingleChildScrollView(
              child: _registerSuccess && !_isInitRegister
                  ? Center(
                      child: Text(
                          'Je bent nu succesvol geregistreerd en ingelogd.'),
                    )
                  : Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            _isRegistering ? 'Registreren' : 'Inloggen',
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        if (!_registerSuccess && !_isInitRegister)
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text('Er ging iets mis bij de registratie.'),
                          ),
                        Form(
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
                                    if (!EmailValidator.validate(val)) {
                                      return 'Dit is geen geldig email-adres.';
                                    } else
                                      return null;
                                  },
                                  onSaved: (val) {
                                    _authData['email'] = val;
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
                                        keyboardType:
                                            TextInputType.visiblePassword,
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
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: _image == null
                                                ? AssetImage(
                                                    'assets/images/image9.jpeg')
                                                : FileImage(_image),
                                          ),
                                          ButtonBar(
                                            buttonPadding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            children: <Widget>[
                                              RaisedButton.icon(
                                                onPressed: () {
                                                  getImage('camera');
                                                },
                                                icon: Icon(Icons.camera),
                                                label: Text('Neem een foto'),
                                              ),
                                              RaisedButton.icon(
                                                onPressed: () {
                                                  getImage('gallery');
                                                },
                                                icon: Icon(Icons.photo_album),
                                                label: Text('Kies een foto'),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  Auth.routeName,
                                                  arguments: {
                                                'registering': !_isRegistering
                                              });
                                        },
                                        child: Text(_isRegistering
                                            ? 'Al een account? Je kunt hier inloggen'
                                            : 'Nog geen account? Je kunt hier registreren'),
                                      ),
                                    ),
                                    ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width / 3,
                                      height: 50,
                                      child: RaisedButton.icon(
                                        onPressed: _isRegistering
                                            ? handleAuth
                                            : handleLogin,
                                        icon: Icon(Icons.verified_user),
                                        color: Theme.of(context).accentColor,
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        label: Text(
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
                      ],
                    ),
            ),
    );
  }
}
