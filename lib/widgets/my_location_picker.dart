import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../providers/geocoder.dart';

class MyLocationPicker extends StatefulWidget {
  final Function _setLocationData;

  MyLocationPicker(this._setLocationData);
  @override
  _MyLocationPickerState createState() => _MyLocationPickerState();
}

class _MyLocationPickerState extends State<MyLocationPicker> {
  Location _location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool _showManualLocation = false;

  @override
  void didChangeDependencies() {
    _checkLocationPermissions();
    super.didChangeDependencies();
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
        setState(() {
          _showManualLocation = true;
        });
        return;
      }
    }
    _locationData = await _location.getLocation();
    widget._setLocationData(_locationData);
  }

  void _convertCodeToLocation(String val) async {
    if (val.length == 4) {
      var data = await GeoCoder.getCoordinatesFromPostCode(val);
      _locationData = LocationData.fromMap(data as Map<String, double>);
      widget._setLocationData(_locationData);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _showManualLocation
            ? TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.length != 4) {
                    return 'Dit moeten vier cijfers zijn';
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Postcode',
                    hintText: 'Vul de vier cijfers van je postcode in'),
                onChanged: (val) {
                  _convertCodeToLocation(val);
                },
              )
            : null);
  }
}
