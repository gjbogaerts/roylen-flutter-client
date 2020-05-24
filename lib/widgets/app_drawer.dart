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
import '../screens/auth_profile.dart';
import '../translations/app_drawer.i18n.dart';

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
            title: Text('Meer opties:'.i18n),
            automaticallyImplyLeading: true,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Advertentie overzicht'.i18n),
            subtitle: Text('Alle advertenties, ongefilterd.'.i18n),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          Divider(),
          _user == null
              ? ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Inloggen/registreren'.i18n),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(Auth.routeName,
                        arguments: {'registering': false});
                  },
                )
              : Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Uitloggen'.i18n),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/');
                        Provider.of<AuthProvider.Auth>(context, listen: false)
                            .logout();
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
                      title: Text('Je profiel'.i18n),
                      subtitle: Text('Wijzig je email of je avatar.'.i18n),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AuthProfile.routeName);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Je boodschappen'.i18n),
                      subtitle: Text(
                          'Lees je boodschappen van andere gebruikers, en beantwoord ze hier.'
                              .i18n),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(MessagesScreen.routeName);
                      },
                    ),
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.view_list),
                        title: Text('Jouw advertenties'.i18n),
                        subtitle: Text(
                            'Bewerk of verwijder je eigen advertenties.'.i18n),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(AdUserList.routeName);
                        }),
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('Je biedingen'),
                        subtitle: Text('De biedingen die je hebt gedaan'),
                        onTap: () {
                          print(
                              'Hier worden alle biedingen getoond die je hebt gedaan en kun je ook een deal closen.');
                        })
                  ],
                ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Over Roylen'.i18n),
            subtitle: Text('Contact, privacy, info en wat dies meer zij.'.i18n),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(InfoScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
