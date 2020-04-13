import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class InfoScreen extends StatelessWidget {
  static const routeName = '/info';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Over Roylen'),
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Text('Over ROylen'),
        ));
  }
}
