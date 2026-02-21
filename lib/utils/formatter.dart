import 'package:intl/intl.dart';
import 'constants.dart';

class Formatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.kCurrency,
    decimalDigits: 2,
    customPattern: '#,##0.00 \u00a4',
  );

  static final NumberFormat _compactCurrencyFormat = NumberFormat.currency(
    symbol: AppConstants.kCurrency,
    decimalDigits: 0,
    customPattern: '#,##0 \u00a4',
  );

  static String formatPrice(double price, {bool compact = false}) {
    return compact
        ? _compactCurrencyFormat.format(price)
        : _currencyFormat.format(price);
  }
}
