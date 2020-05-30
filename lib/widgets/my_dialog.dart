import 'package:flutter/material.dart';

class MyDialog extends StatefulWidget {
  final Function _callback;
  final String _title;
  final String _text;
  final String _btnText;
  final String showCancel;
  MyDialog(this._callback, this._title, this._text, this._btnText,
      {this.showCancel = ''});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 25,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(widget._title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text(widget._text)],
        ),
      ),
      actions: <Widget>[
        widget.showCancel == ''
            ? null
            : FlatButton(
                textColor: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(widget.showCancel),
              ),
        RaisedButton(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Text(widget._btnText,
              style: Theme.of(context).textTheme.bodyText2),
          color: Theme.of(context).accentColor,
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            widget._callback();
          },
        )
      ],
    );
  }
}
