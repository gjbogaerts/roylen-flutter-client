import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/messages.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  var _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _message;
  bool _messageSent = false;
  String _error;
  void _sendMessage() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    var _result = await Provider.of<Messages>(context)
        .sendContactMessage(_message, _email, _name);
    if (_result) {
      setState(() {
        _messageSent = true;
      });
    } else {
      setState(() {
        _error =
            'Je boodschap kon niet worden verzonden. Probeer het later nog eens.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _messageSent
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Je boodschap is verstuurd',
                style: Theme.of(context).textTheme.body2,
              ),
            ),
          )
        : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _error,
                    style: Theme.of(context).textTheme.body2,
                  ),
                ),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text('Contact met Roylen',
                          style: Theme.of(context).textTheme.title),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Je naam'),
                        validator: (val) =>
                            val.isEmpty ? 'Je moet je naam invullen.' : null,
                        onSaved: (val) {
                          _name = val;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Je email'),
                        validator: (val) => val.isEmpty
                            ? 'Je moet je emailadres invullen.'
                            : null,
                        onSaved: (val) {
                          _email = val;
                        },
                      ),
                      TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Je boodschap'),
                          validator: (val) => val.isEmpty
                              ? 'Je moet een boodschap achterlaten.'
                              : null,
                          maxLines: 3,
                          onSaved: (val) {
                            _message = val;
                          }),
                      RaisedButton(
                        onPressed: _sendMessage,
                        child: Text('Versturen'),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
  }
}
