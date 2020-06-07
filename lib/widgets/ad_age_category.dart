import 'package:flutter/material.dart';

class AdAgeCategory extends StatefulWidget {
  final Function callback;
  AdAgeCategory(this.callback);
  @override
  _AdAgeCategoryState createState() => _AdAgeCategoryState();
}

class _AdAgeCategoryState extends State<AdAgeCategory> {
  String _ageCategory;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: _ageCategory,
        icon: Icon(Icons.arrow_drop_down_circle),
        iconSize: 24,
        iconEnabledColor: Theme.of(context).primaryColor,
        elevation: 16,
        isExpanded: true,
        hint: Text('Voor welke leeftijd?',
            style: TextStyle(color: Theme.of(context).primaryColor)),
        style: TextStyle(color: Theme.of(context).primaryColor),
        underline: Container(
          height: 1,
          color: Theme.of(context).primaryColor,
        ),
        dropdownColor: Theme.of(context).accentColor,
        items: <String>['0-1', '2-4', '5-6', '7-10', '10-12', '12-16', '0-16']
            .map<DropdownMenuItem<String>>((String e) =>
                DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        onChanged: (String val) {
          widget.callback(val);
          setState(() {
            _ageCategory = val;
          });
        });
  }
}
