import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/ad.dart';
import '../providers/messages.dart';

class Contact extends StatefulWidget {
  final User _user;
  final Ad _ad;
  Contact(this._user, this._ad);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  var _formKey = GlobalKey<FormState>();
  String _messageToSend;

  void sendMessage() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    var _sendResult = await Provider.of<Messages>(context, listen: false)
        .sendMessage(
            adId: widget._ad.id,
            adTitle: widget._ad.title,
            message: _messageToSend,
            toId: widget._ad.creator.id);
    if (!_sendResult) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Er ging iets mis'),
          content: Text(Provider.of<Messages>(context).err),
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Je bericht is verzonden'),
          content: Text('Je bericht is verzonden. Nu maar afwachten...'),
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'Je naam'),
                      initialValue: widget._user.screenName,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Je email-adres'),
                      readOnly: true,
                      initialValue: widget._user.email,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Je boodschap'),
                      maxLines: 3,
                      minLines: 2,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Je moet een boodschap achterlaten.';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _messageToSend = val;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                            color: Theme.of(context).canvasColor,
                            textColor: Theme.of(context).primaryColor,
                            child: Text('Laat maar zitten'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColor,
                          child: Text('Versturen'),
                          onPressed: sendMessage,
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
