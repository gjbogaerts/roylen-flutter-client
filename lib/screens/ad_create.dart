import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../providers/auth.dart';
import '../providers/toaster.dart';
import '../models/user.dart';
import '../providers/ads.dart';
import '../widgets/ad_form.dart';
import '../screens/auth.dart' as AuthScreen;
import '../screens/home.dart';
import '../widgets/background.dart';
import '../widgets/my_dialog.dart';

class AdCreate extends StatefulWidget {
  static const routeName = '/add-create';
  @override
  _AdCreateState createState() => _AdCreateState();
}

class _AdCreateState extends State<AdCreate> {
  User _user;
  Location _location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void didChangeDependencies() {
    var provider = Provider.of<Auth>(context);
    if (provider.isAuth) {
      _user = provider.getUser();
      _checkLocationPermissions();
    }
    super.didChangeDependencies();
  }

  Future<void> _saveForm(Map<String, dynamic> formData) async {
    formData['latitude'] = _locationData.latitude;
    formData['longitude'] = _locationData.longitude;
    var result = await Provider.of<Ads>(context, listen: false)
        .createAd(formData, _user.token);
    if (result) {
      Provider.of<Toaster>(context, listen: false)
          .setMessage('Je advertentie is aangemaakt');
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  Future<void> _checkLocationPermissions() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await _location.getLocation();
  }

  void navigateToAuth() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            settings: RouteSettings(arguments: {'registering': false}),
            builder: (BuildContext context) => AuthScreen.Auth()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(),
        _user == null
            ? MyDialog(
                navigateToAuth,
                'Niet ingelogd',
                'Je moet ingelogd zijn om een advertentie te kunnen maken.',
                'Log in')
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Plaats je advertentie',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    AdForm(_saveForm)
                  ],
                ),
              ),
      ],
    );
  }
}
