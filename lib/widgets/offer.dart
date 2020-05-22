import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/ad.dart';
import '../providers/offers.dart';

class Offer extends StatefulWidget {
  final User _user;
  final Ad _ad;
  Offer(this._user, this._ad);

  @override
  _OfferState createState() => _OfferState();
}

class _OfferState extends State<Offer> {
  var _formKey = GlobalKey<FormState>();
  String _offeredNix;

  void _sendOffer() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      await Provider.of<Offers>(context, listen: false).setOffer(
          ad: widget._ad,
          fromUser: widget._user,
          offerAmount: int.parse(_offeredNix));
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Verzonden'),
          content: Text(
              'Je bod is verzonden. Hopelijk krijg je een mooie reactie terug...'),
        ),
      );
    } catch (err) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Er ging iets mis: $err'),
          content: Text(Provider.of<Offers>(context).err.toString()),
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
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Je naam'),
                      initialValue: widget._user.screenName,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Je email-adres'),
                      readOnly: true,
                      enabled: false,
                      initialValue: widget._user.email,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Nix',
                          hintText: 'Hoeveel nix wil je bieden?'),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val.isEmpty ||
                            int.tryParse(val) == null ||
                            int.tryParse(val) < 0 ||
                            int.tryParse(val) > 999) {
                          return 'Vul een bod in tussen 0 en 1000 nix.';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _offeredNix = val;
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
                          onPressed: _sendOffer,
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
