import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/offer.dart';
import '../utils/date_string.dart';
import '../providers/messages.dart';
import '../providers/offers.dart';
import './my_dialog.dart';

class AdOffer extends StatefulWidget {
  final List<Offer> _offers;
  final String _adId;
  final String _adTitle;
  AdOffer(this._offers, this._adId, this._adTitle);
  @override
  _AdOfferState createState() => _AdOfferState();
}

class _AdOfferState extends State<AdOffer> {
  void _sendReturnOffer(Offer offer, String msg) async {
    var _result = await Provider.of<Messages>(context, listen: false)
        .sendMessage(
            toId: offer.fromUser.id,
            adId: widget._adId,
            adTitle: widget._adTitle,
            message: msg);
    showDialog(
        builder: (context) => _result
            ? MyDialog(Navigator.of(context).pop, 'Boodschap verstuurd',
                'Je boodschap is verstuurd.', 'OK')
            : MyDialog(
                Navigator.of(context).pop,
                'Boodschap niet verstuurd',
                'Er is een probleem opgetreden. Je boodschap kon niet worden verstuurd. Excuus!',
                'OK'),
        context: context);
  }

  void _handleAcceptClick(Offer _offer) async {
    var _result = await Provider.of<Offers>(context, listen: false)
        .acceptOffer(_offer, widget._adTitle);
    showDialog(
        context: context,
        builder: (context) => _result
            ? MyDialog(
                Navigator.of(context).pop,
                'Mededeling verzonden',
                'Je kunt nu afspraken maken om je product in te wisselen of te lenen',
                'OK')
            : MyDialog(
                Navigator.of(context).pop,
                'Fout!',
                'Er is iets fout gegaan. Wilt u het later nog een sproberen? Excuus!',
                'OK'));
  }

  void _handleAnswerClick(Offer offer) {
    var _msgController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  8, 8, 8, MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextField(
                      autocorrect: true,
                      autofocus: true,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(labelText: 'Je boodschap'),
                      controller: _msgController,
                    ),
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
                        onPressed: () {
                          _sendReturnOffer(offer, _msgController.text);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  List<Widget> _generateOffers(context) {
    List<Widget> _offerViews = [];
    for (int i = 0; i < widget._offers.length; i++) {
      Offer _offer = widget._offers[i];
      _offerViews.add(Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                  '${_offer.fromUser.screenName} bood ${_offer.amount} nix'),
            ),
            Container(
              child: Text(DateString.convert(_offer.dateAdded)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: OutlineButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      _handleAnswerClick(_offer);
                    },
                    child: Text('Antwoord'),
                  ),
                ),
                Container(
                    child: RaisedButton(
                        onPressed: () {
                          _handleAcceptClick(_offer);
                        },
                        child: Text('Accepteren')))
              ],
            )
          ],
        ),
      ));
    }
    return _offerViews;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _generateOffers(context),
      ),
    );
  }
}
