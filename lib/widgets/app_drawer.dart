import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/server_interface.dart';
import '../screens/auth.dart';
import '../providers/auth.dart' as AuthProvider;
import '../models/user.dart';
import '../screens/home.dart';
import '../screens/info.dart';
import '../screens/messages.dart';
import '../screens/ad_user_list.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  User _user;
  var baseUrl = ServerInterface.getBaseUrl();

  @override
  void didChangeDependencies() {
    setState(() {
      _user = Provider.of<AuthProvider.Auth>(context).getUser();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Meer opties:'),
            automaticallyImplyLeading: true,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Advertentie overzicht'),
            subtitle: Text('Alle advertenties, ongefilterd.'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          Divider(),
          _user == null
              ? ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Inloggen/registreren'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(Auth.routeName,
                        arguments: {'registering': false});
                  },
                )
              : Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Uitloggen'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/');
                        Provider.of<AuthProvider.Auth>(context).logout();
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: _user.avatar == null
                            ? AssetImage('assets/images/image9.jpeg')
                            : NetworkImage(_user.avatar.startsWith('http')
                                ? _user.avatar
                                : '$baseUrl${_user.avatar}'),
                        radius: 15,
                      ),
                      title: Text('Je profiel'),
                      subtitle: Text('Wijzig je email of je avatar'),
                      onTap: () {
                        print('Hier profiel bewerken functinoaliteint.');
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Je boodschappen'),
                      subtitle: Text(
                          'Lees je boodschappen van andere gebruikers, en beantwoord ze hier.'),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(MessagesScreen.routeName);
                      },
                    ),
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.view_list),
                        title: Text('Jouw advertenties'),
                        subtitle:
                            Text('Bewerk of verwijder je eigen advertenties'),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(AdUserList.routeName);
                        })
                  ],
                ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Over Roylen'),
            subtitle: Text('Contact, privacy, info en wat dies meer zij'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(InfoScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
