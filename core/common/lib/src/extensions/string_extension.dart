extension StringExtension on String {
  int convertToInt() {
    try {
      return num.tryParse(trim())?.toInt() ?? 0;
    } catch (e) {
      return 0;
    }
  }

  String formatPhone() {
    if (this.startsWith('+88')) {
      return this;
    } else if (this.startsWith('01')) {
      return '+88$this';
    } else {
      return this;
    }
  }
}
