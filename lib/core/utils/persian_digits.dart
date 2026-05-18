const _persianDigits = '۰۱۲۳۴۵۶۷۸۹';

extension IntToPersian on int {
  String toPersian() {
    return toString().split('').map((c) => _persianDigits[int.parse(c)]).join();
  }
}

extension StringToPersian on String {
  String toPersianDigits() {
    return split('').map((c) {
      final digit = int.tryParse(c);
      if (digit != null) return _persianDigits[digit];
      return c;
    }).join();
  }
}
