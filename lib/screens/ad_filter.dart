import 'package:flutter/material.dart';

class AdFilter extends StatefulWidget {
  static const routeName = '/ad-filter';
  @override
  _AdFilterState createState() => _AdFilterState();
}

class _AdFilterState extends State<AdFilter> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Filter ad'),
    );
  }
}
