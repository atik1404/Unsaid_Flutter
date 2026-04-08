extension StringExtension on String {
  int convertToInt() {
    try {
      return num.tryParse(trim())?.toInt() ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
