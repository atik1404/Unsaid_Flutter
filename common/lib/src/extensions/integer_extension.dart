extension IntegerExtension on int {
  String convertToString() {
    try {
      return toString();
    } catch (e) {
      return '';
    }
  }
}
