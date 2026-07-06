extension IntegerExtension on int {
  String convertToString() {
    try {
      return toString();
    } catch (e) {
      return '';
    }
  }

  /// Converts a number into a compact, human-readable string with a unit
  /// suffix (K, M, B, T).
  ///
  /// e.g. 999 -> "999", 1500 -> "1.5K", 1000000 -> "1M",
  /// 2500000000 -> "2.5B". Negative numbers keep their sign.
  ///
  /// [decimals] controls the number of fraction digits shown (default 1).
  /// Trailing zeros in the fraction are removed.
  String toCompactString({int decimals = 1}) {
    if (this == 0) return '0';

    final isNegative = this < 0;
    final absValue = abs();

    const units = <int, String>{
      1000000000000: 'T',
      1000000000: 'B',
      1000000: 'M',
      1000: 'K',
    };

    for (final entry in units.entries) {
      if (absValue >= entry.key) {
        final value = absValue / entry.key;
        final formatted = _trimTrailingZeros(
          value.toStringAsFixed(decimals),
        );
        return '${isNegative ? '-' : ''}$formatted${entry.value}';
      }
    }

    return toString();
  }

  String _trimTrailingZeros(String value) {
    if (!value.contains('.')) return value;
    return value.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}
