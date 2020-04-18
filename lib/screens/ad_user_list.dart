import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../models/ad.dart';
import '../providers/ads.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';

class AdUserList extends StatefulWidget {
  static const routeName = '/ad-user-list';
  @override
  _AdUserListState createState() => _AdUserListState();
}

class _AdUserListState extends State<AdUserList> {
  User _user;
  List<Ad> _userAds;
  bool _isLoading = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var adsProvider = Provider.of<Ads>(context);
    var authProvider = Provider.of<Auth>(context);
    if (authProvider.isAuth) {
      _user = authProvider.getUser();
    }
    if (_user != null) {
      _userAds = await adsProvider.fetchItemsFromUser(_user.id);
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Je advertenties'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: _userAds.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Theme.of(context).cardColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _userAds[idx].title,
                            style: Theme.of(context).textTheme.body2,
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    print('start editing');
                                  }),
                              IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () {
                                  print('delete');
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
    );
  }
}
