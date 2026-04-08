extension NumberExtension on num {
  String formatWithCommas() {
    final isNegative = this < 0;
    var s = abs().toString();
    s = s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return isNegative ? '-$s' : s;
  }
}
