import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../widgets/background.dart';

import '../translations/auth_password_reset.i18n.dart';

class AuthPasswordReset extends StatefulWidget {
  static const routeName = '/auth_password_reset';
  final String resetKey;

  AuthPasswordReset({this.resetKey});

  @override
  _AuthPasswordResetState createState() => _AuthPasswordResetState();
}

class _AuthPasswordResetState extends State<AuthPasswordReset> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String _email;
  String _resetCode;
  String _pw;
  String _pw2;

  void _showDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).accentColor,
            child: Text('OK'.i18n),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _handleEmailSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    var _result = await Provider.of<Auth>(context, listen: false)
        .startResetPasswordSequence(_email);
    if (!_result) {
      _showDialog('Mislukt'.i18n, 'Excuus, er ging iets mis'.i18n);
    } else {
      _showDialog(
          'Gelukt'.i18n,
          'Je hebt een email gekregen met een code erin. Vul deze code hieronder in en maak een nieuw wachtwoord aan.'
              .i18n);
    }
  }

  void _handlePasswordReset() async {
    if (!_formKey2.currentState.validate()) {
      return;
    }
    _formKey2.currentState.save();
    print(_pw2);
    var _result = await Provider.of<Auth>(context, listen: false)
        .finishResetPasswordSequence(_resetCode, _pw);
    if (!_result) {
      _showDialog('Mislukt'.i18n, 'Excuus, er ging iets mis'.i18n);
    } else {
      _showDialog(
          'Gelukt'.i18n, 'Je kunt nu inloggen met je nieuwe wachtwoord'.i18n);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wachtwoord vergeten'.i18n),
      ),
      body: Stack(
        children: <Widget>[
          Background(),
          SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 8, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Vul hier eerst je emailadres in, en klik dan op verzenden. Je krijgt dan een code toegestuurd waarmee je hieronder een nieuw wachtwoord kunt aanmaken.'
                        .i18n,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Je emailadres'.i18n),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val.isEmpty
                            ? 'Je moet een emailadres invullen'.i18n
                            : null,
                        onSaved: (val) {
                          _email = val;
                        },
                      ),
                      SizedBox(height: 10),
                      RaisedButton(
                        child: Text('Versturen'.i18n),
                        onPressed:
                            _handleEmailSubmit, /* 
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColor, */
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 10,
                ),
                Form(
                  key: _formKey2,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue:
                            widget.resetKey != null ? widget.resetKey : '',
                        readOnly: widget.resetKey != null ? true : false,
                        decoration: InputDecoration(labelText: 'Je code'.i18n),
                        validator: (val) => val.isEmpty
                            ? 'Je moet een code invullen'.i18n
                            : null,
                        onSaved: (val) {
                          _resetCode = val;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Je nieuwe wachtwoord'.i18n),
                        validator: (val) => val.isEmpty
                            ? 'Je moet een wachtwoord invullen'.i18n
                            : null,
                        onChanged: (val) {
                          setState(() {
                            _pw = val;
                          });
                        },
                        onSaved: (val) {
                          _pw = val;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Herhaal je wachtwoord'.i18n),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Je moet je wachtwoord nog een keer invullen'
                                .i18n;
                          }
                          if (val != _pw) {
                            return 'De wachtwoorden zijn niet gelijk.'.i18n;
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _pw2 = val;
                        },
                      ),
                      RaisedButton(
                        onPressed: _handlePasswordReset,
                        child: Text('Versturen'
                            .i18n), /* 
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColor, */
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
