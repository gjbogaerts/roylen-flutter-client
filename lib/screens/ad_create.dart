import 'package:flutter/material.dart';

import '../widgets/ad_form.dart';

class AdCreate extends StatefulWidget {
  static const routeName = '/add-create';
  @override
  _AdCreateState createState() => _AdCreateState();
}

class _AdCreateState extends State<AdCreate> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(
              'Plaats je advertentie',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          AdForm()
        ],
      ),
    );
  }
}
