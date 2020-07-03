import 'dart:convert';
import 'dart:math';

class Crypto {
  static final Random _random = Random.secure();

  static String createRandomCryptoString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }
}
