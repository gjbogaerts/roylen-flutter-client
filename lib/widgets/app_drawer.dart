import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/server_interface.dart';
import '../screens/auth.dart';
import '../providers/auth.dart' as AuthProvider;
import '../models/user.dart';
import '../screens/home.dart';
import '../screens/info.dart';
import '../screens/messages.dart';

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
            subtitle: Text('Klik hier om alle advertenties te zien'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          Divider(),
          _user == null
              ? ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Inloggen/registreren'),
                  subtitle:
                      Text('Klik hier om in te loggen of je te registreren'),
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
                      subtitle: Text('Klik hier om uit te loggen'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/');
                        Provider.of<AuthProvider.Auth>(context).logout();
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            _user.avatar.startsWith('http')
                                ? _user.avatar
                                : '$baseUrl${_user.avatar}'),
                        radius: 15,
                      ),
                      title: Text('Je profiel'),
                      subtitle: Text('Klik hier om je profiel bij te wennen'),
                      onTap: () {
                        print('Hier profiel bewerken functinoaliteint.');
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Je boodschappen'),
                      subtitle: Text('Klik hier om je boodschappen te lezen'),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(MessagesScreen.routeName);
                      },
                    )
                  ],
                ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Over Roylen'),
            subtitle: Text('Klik hier om meer te weten over Roylen'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(InfoScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
