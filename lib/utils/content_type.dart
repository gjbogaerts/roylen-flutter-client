import 'package:http_parser/http_parser.dart';

class ContentType {
  static String getContentType(fileName) {
    String contentType;
    if (fileName.endsWith('jpeg') || fileName.endsWith('jpg')) {
      contentType = 'image/jpeg';
    } else if (fileName.endsWith('png')) {
      contentType = 'image/png';
    } else if (fileName.endsWith('gif')) {
      contentType = 'image/gif';
    } else {
      contentType = 'application/octet-stream';
    }
    return contentType;
  }

  static MediaType getContentTypeAsMap(fileName) {
    if (fileName.endsWith('jpeg') || fileName.endsWith('jpg')) {
      return MediaType('image', 'jpeg');
    } else if (fileName.endsWith('png')) {
      return MediaType('image', 'png');
    } else if (fileName.endsWith('gif')) {
      return MediaType('image', 'gif');
    } else {
      return MediaType('application', 'octet-stream');
    }
  }
}
