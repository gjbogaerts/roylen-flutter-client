import 'package:flutter/material.dart';
import '../models/offer.dart';

class AdOffer extends StatefulWidget {
  final List<Offer> _offers;
  AdOffer(this._offers);
  @override
  _AdOfferState createState() => _AdOfferState();
}

class _AdOfferState extends State<AdOffer> {
  List<Widget> _generateOffers(context) {
    List<Widget> _offerViews = [];
    for (int i = 0; i < widget._offers.length; i++) {
      Offer _offer = widget._offers[i];
      _offerViews.add(Column(
        children: <Widget>[
          Container(
            child:
                Text('${_offer.fromUser.screenName} bood ${_offer.amount} nix'),
          ),
          Container(
            child: Text(_offer.dateAdded),
          )
        ],
      ));
    }
    return _offerViews;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _generateOffers(context));
  }
}
