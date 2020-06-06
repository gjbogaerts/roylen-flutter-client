import 'package:flutter/material.dart';

class Toaster with ChangeNotifier {
  var _hasMessage = false;
  String _message;

  bool get message {
    return _hasMessage;
  }

  void setMessage(String msg) {
    _message = msg;
    _hasMessage = true;
    notifyListeners();
  }

  String getMessage() {
    return _message;
  }

  void clearMessage() {
    _message = null;
    _hasMessage = false;
    notifyListeners();
  }

  void showSnackBar(BuildContext context) {
    if (_hasMessage) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        content: Text(
          _message,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Theme.of(context).accentColor),
        ),
      ));
      clearMessage();
    }
  }
}
