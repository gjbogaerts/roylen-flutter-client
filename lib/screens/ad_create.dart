import 'package:flutter/material.dart';

class AdCreate extends StatefulWidget {
  static const routeName = '/add-create';
  @override
  _AdCreateState createState() => _AdCreateState();
}

class _AdCreateState extends State<AdCreate> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Create ad'),
    );
  }
}
