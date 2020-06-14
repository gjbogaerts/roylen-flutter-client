import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/ads.dart';
import '../providers/auth.dart';
import '../providers/toaster.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background.dart';
import '../widgets/ad_offer.dart';
import '../screens/home.dart';

class AdUserList extends StatefulWidget {
  static const routeName = '/ad-user-list';
  @override
  _AdUserListState createState() => _AdUserListState();
}

class _AdUserListState extends State<AdUserList> {
  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // print('change');
    var authProvider = Provider.of<Auth>(context);
    if (authProvider.isAuth) {
      _user = authProvider.getUser();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed('/');
      });
    }
  }

/*   void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('TO DO'),
              content: Text(
                  'Je kunt advertenties op dit moment nog niet wijzigen. Hier wordt aan gewerkt. Op dit moment is je enige optie om de advertentie te verwijderen, en daarna een nieuwe aan te maken. Excuus voor de overlast.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  } */

  Center _adInvite(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Je hebt nog geen advertenties aangemaakt.',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName,
                  arguments: {'idx': 4});
            },
            color: Theme.of(context).primaryColor,
            child: Text('Maak een nieuwe advertentie'),
          )
        ],
      ),
    );
  }

  Builder _adUserList(BuildContext context, AsyncSnapshot result) {
    return Builder(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            Provider.of<Toaster>(context, listen: false).showSnackBar(context));
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: result.data.length,
              itemBuilder: (context, idx) {
                var curItem = result.data[idx];
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                curItem.title,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                /* IconButton(
                                    color: Theme.of(context).primaryColor,
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _showAlert(context);
                                    }), */
                                IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    _confirmDeletion(context, curItem.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        curItem.offers.length > 0
                            ? AdOffer(curItem.offers, curItem.id, curItem.title)
                            : Text('Je hebt nog geen aanbiedingen')
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  void _confirmDeletion(BuildContext ctx, String adId) async {
    await showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Verwijderen?'),
        content:
            Text('Weet je zeker dat je deze advertentie wilt verwijderen?'),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Nee, niet weg'),
            color: Theme.of(ctx).accentColor,
            textColor: Theme.of(ctx).primaryColor,
          ),
          RaisedButton(
            color: Theme.of(ctx).accentColor,
            textColor: Theme.of(ctx).primaryColor,
            onPressed: () async {
              var result =
                  await Provider.of<Ads>(ctx, listen: false).removeAd(adId);
              if (result) {
                Provider.of<Toaster>(context, listen: false)
                    .setMessage('Je advertentie is verwijderd.');
              } else {
                Provider.of<Toaster>(context, listen: false)
                    .setMessage('Je advertentie kon niet worden verwijderd.');
              }
              Navigator.of(ctx).pop();
            },
            child: Text('Ja, mag weg'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Je advertenties'),
          actions: <Widget>[
            GestureDetector(
              child: Icon(Icons.add_circle_outline),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(HomeScreen.routeName,
                    arguments: {'idx': 4});
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<Ads>(context).fetchItemsFromUser(_user.id),
            builder: (context, result) {
              return Stack(
                children: <Widget>[
                  Background(),
                  result.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : result.data.length == 0
                          ? _adInvite(context)
                          : _adUserList(context, result)
                ],
              );
            }));
  }
}
