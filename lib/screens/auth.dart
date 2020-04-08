import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/app_drawer.dart';

class Auth extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();
  var _image;

  Future getImage(String source) async {
    var image;
    if (source == 'camera') {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    print(image);
    setState(() {
      _image = image;
    });
  }

  Column _showRegisterFields() {
    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: false,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            hintText: 'Je wachtwoord',
            labelText: 'Herhaal je wachtwoord',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Je schermnaam',
            hintText: 'Kies een schermnaam',
          ),
        ),
        SizedBox(height: 10),
        ButtonBar(
          buttonPadding: EdgeInsets.all(10),
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
        )
      ],
    );
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
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              _isRegistering ? 'Registreren' : 'Inloggen',
              style: Theme.of(context).textTheme.title,
            ),
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      hintText: 'Je wachtwoord',
                      labelText: 'Wachtwoord',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_isRegistering) _showRegisterFields(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                                Auth.routeName,
                                arguments: {'registering': !_isRegistering});
                          },
                          child: Text(_isRegistering
                              ? 'Al een account? Je kunt hier inloggen'
                              : 'Nog geen account? Je kunt hier registreren'),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width / 3,
                        height: 50,
                        child: RaisedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.verified_user),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColor,
                          label: Text(
                            'Inloggen',
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
    );
  }
}
