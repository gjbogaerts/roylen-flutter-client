import 'package:flutter/material.dart';

import '../screens/auth.dart';
import '../screens/ads_list.dart';

class AppDrawer extends StatelessWidget {
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
              Navigator.of(context).pushReplacementNamed(AdsList.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Inloggen/registreren'),
            subtitle: Text('Klik hier om in te loggen of je te registreren'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Auth.routeName);
            },
          )
        ],
      ),
    );
  }
}
