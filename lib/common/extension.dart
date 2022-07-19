extension LabelPrice on int {
  String withPriceLabel() {
    return '$this تومان';
  }
}

extension CustomFaPrice on String {
  String toFaNumber() {
    return replaceAll('1', '۱')
        .replaceAll('2', '۲')
        .replaceAll('3', '۳')
        .replaceAll('4', '۴')
        .replaceAll('5', '۵')
        .replaceAll('6', '۶')
        .replaceAll('7', '۷')
        .replaceAll('8', '۸')
        .replaceAll('9', '۹')
        .replaceAll('0', '۰');
  }

  String addComma({bool priceLabel = true}) {
    String number = this;
    String str = "";
    var numberSplit = number.split('.');
    number = numberSplit[0].replaceAll(',', '');
    for (var i = number.length; i > 0;) {
      if (i > 3) {
        str = ',' + number.substring(i - 3, i) + str;
      } else {
        str = number.substring(0, i) + str;
      }
      i = i - 3;
    }
    if (numberSplit.length > 1) {
      str += '.' + numberSplit[1];
    }
    if (priceLabel) {
      return str + ' تومان';
    } else {
      return str;
    }
  }
}
