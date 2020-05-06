import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:i18n_extension/i18n_extension.dart';
import '../providers/auth.dart';
import '../widgets/background.dart';

extension Localization on String {
  static var t = Translations("nl_nl") +
      {"nl_nl": "OK", "en_us": "OK"} +
      {"nl_nl": "Mislukt", "en_us": "Failure"} +
      {
        "nl_nl": "Excuus, er ging iets mis",
        "en_us": "Our apologies, something went wrong"
      } +
      {"nl_nl": "Gelukt", "en_us": "Success"} +
      {
        "nl_nl":
            "Je hebt een email gekregen met een code erin. Vul deze code hieronder in en maak een nieuw wachtwoord aan.",
        "en_us":
            "You have received an email containing a secret key. Please fill out this code underneath and create a new password."
      } +
      {
        "nl_nl": "Je kunt nu inloggen met je nieuwe wachtwoord",
        "en_us": "You can now log in with your new password"
      } +
      {"nl_nl": "Wachtwoord vergeten", "en_us": "Forgot password"} +
      {
        "nl_nl":
            "Vul hier eerst je emailadres in, en klik dan op verzenden. Je krijgt dan een code toegestuurd waarmee je hieronder een nieuw wachtwoord kunt aanmaken.",
        "en_us":
            "Please fill out your email address underneath, and click Send. You'll get a key in your mail that you can use to create a new password."
      } +
      {"nl_nl": "Je emailadres", "en_us": "Your email address"} +
      {
        "nl_nl": "Je moet een emailadres invullen",
        "en_us": "You have to fill out a valid email address"
      } +
      {"nl_nl": "Versturen", "en_us": "Send"} +
      {"nl_nl": "Je code", "en_us": "Your secret key"} +
      {
        "nl_nl": "Je moet een code invullen",
        "en_us": "You have to fill out your secret key"
      } +
      {"nl_nl": "Je nieuwe wachtwoord", "en_us": "Your new password"} +
      {
        "nl_nl": "Je moet een wachtwoord invullen",
        "en_us": "You have to fill out a password"
      } +
      {
        "nl_nl": "Herhaal je wachtwoord",
        "en_us": "Please fill out your password again"
      } +
      {
        "nl_nl": "Je moet je wachtwoord nog een keer invullen",
        "en_us": "You have to fill out your password once more"
      } +
      {
        "nl_nl": "De wachtwoorden zijn niet gelijk.",
        "en_us": "The passwords are not equal"
      };
  String get i18n => localize(this, t);
}

class AuthPasswordReset extends StatefulWidget {
  static const routeName = '/auth_password_reset';

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
    var _result =
        await Provider.of<Auth>(context).startResetPasswordSequence(_email);
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
    var _result = await Provider.of<Auth>(context)
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
                    style: Theme.of(context).textTheme.body2,
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
