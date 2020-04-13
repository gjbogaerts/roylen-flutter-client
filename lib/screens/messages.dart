import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class MessagesScreen extends StatefulWidget {
  static const routeName = '/messages';
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Je boodschappen')),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Alle boodschappen'),
      ),
    );
  }
}
