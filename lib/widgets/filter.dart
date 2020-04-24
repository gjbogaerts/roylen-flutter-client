import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  final Function filterCallback;

  Filter(this.filterCallback);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String _filterElements;
  var _formKey = GlobalKey<FormState>();

  void setSearch() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    widget.filterCallback(_filterElements);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(labelText: 'Zoekterm'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Je moet een zoekterm invullen.';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _filterElements = val;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                            color: Theme.of(context).canvasColor,
                            textColor: Theme.of(context).primaryColor,
                            child: Text('Laat maar zitten'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColor,
                            child: Text('Zoeken'),
                            onPressed: () {
                              setSearch();
                            })
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
