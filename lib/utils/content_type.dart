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
}
