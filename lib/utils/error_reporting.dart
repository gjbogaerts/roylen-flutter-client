import 'package:sentry/sentry.dart';
// import 'package:flutter/material.dart';

class ErrorReporting {
  final SentryClient _sentry = SentryClient(
      dsn:
          'https://bac064cb128d4026ac11b59c4e9c293c@o391130.ingest.sentry.io/5236754');

  bool _inDebugMode = false;

  bool get isInDebugMode {
    assert(_inDebugMode = true);
    return _inDebugMode;
  }

  Future<void> reportError(dynamic error, dynamic stackTrace) async {
    print('Caught error $error');
    if (_inDebugMode) {
      print(stackTrace);
    } else {
      _sentry.captureException(exception: error, stackTrace: stackTrace);
    }
  }
}
