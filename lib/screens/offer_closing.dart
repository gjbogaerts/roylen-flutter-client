import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/offers.dart';
import '../providers/auth.dart';
import '../models/offer.dart';
import '../widgets/background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/my_dialog.dart';
import '../utils/server_interface.dart';

class OfferClosing extends StatefulWidget {
  static const routeName = './offer-closing';
  @override
  _OfferClosingState createState() => _OfferClosingState();
}

class _OfferClosingState extends State<OfferClosing> {
  Future<List<Offer>> _loadedOffers;
  String _senderId;
  String _receiverId;
  String _offerId;
  int _transactionAmount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadedOffers = Provider.of<Offers>(context).getOffersFromUser();
    _senderId = Provider.of<Auth>(context).getUser().id;
  }

  void _showErrorDialog(String err) {
    showDialog(
      context: context,
      builder: (context) =>
          MyDialog(Navigator.of(context).pop, 'Helaas', err, 'OK'),
    );
  }

  void _finalizeTransfer() async {
    try {
      var _result = await Provider.of<Offers>(context, listen: false)
          .finalizeTransaction(
              _offerId, _senderId, _receiverId, _transactionAmount);
      Navigator.of(context).pop();
      _result
          ? showDialog(
              context: context,
              builder: (context) => MyDialog(Navigator.of(context).pop,
                  'Succes', 'De transactie is geslaagd', 'OK'),
            )
          : _showErrorDialog(
              'Er ging iets mis tijdens de transactie. Wil je het opnieuw proberen?');
    } catch (err) {
      _showErrorDialog(err.toString());
    }
  }

  void _transferAmount(Offer offer) {
    showDialog(
      context: context,
      builder: (context) => MyDialog(
        _finalizeTransfer,
        'Overboeken?',
        'Als je op OK klikt, wordt er ${offer.amount} nix overgeboekt. Doe dit bij de overhandiging van je geruilde product. Weet je zeker dat je dit wilt?',
        'OK',
        showCancel: 'Nee, toch niet',
      ),
    );
    _transactionAmount = offer.amount;
    _receiverId = offer.adCreatorId;
    _offerId = offer.id;
  }

  @override
  Widget build(BuildContext context) {
    var _baseUrl = ServerInterface.getBaseUrl();
    return Scaffold(
      appBar: AppBar(
        title: Text('Je biedingen'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _loadedOffers,
        builder: (context, snapshot) {
          return Stack(
            children: <Widget>[
              Background(),
              snapshot.connectionState == ConnectionState.waiting
                  ? CircularProgressIndicator()
                  : snapshot.data.length == 0
                      ? Center(
                          child:
                              Text('Je hebt nog geen biedingen uitgebracht.'),
                        )
                      : Container(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, idx) {
                                Offer _currentOffer =
                                    snapshot.data[idx] as Offer;
                                if (_currentOffer.closed) {
                                  return SizedBox(
                                    height: 0,
                                  );
                                }
                                return ListTile(
                                  isThreeLine: true,
                                  leading: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        '$_baseUrl${_currentOffer.adPic}'),
                                  ),
                                  title: Text(
                                    'Je hebt ${_currentOffer.amount} nix geboden op ${_currentOffer.adTitle}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  subtitle: _currentOffer.accepted &&
                                          !_currentOffer.closed
                                      ? FlatButton(
                                          textColor:
                                              Theme.of(context).primaryColor,
                                          onPressed: () {
                                            _transferAmount(_currentOffer);
                                          },
                                          child: Text(
                                              'Dit bod is geaccepteerd. Maak ${_currentOffer.amount} nix over.'))
                                      : Text(
                                          'Dit bod is (nog) niet geaccepteerd.'),
                                );
                              }),
                        )
            ],
          );
        },
      ),
    );
  }
}
