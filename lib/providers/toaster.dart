import 'package:flutter/foundation.dart';

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
}
