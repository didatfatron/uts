
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/exchange_rate.dart';

class ExchangeRateService {
  static const String _url =
      'https://api.frankfurter.dev/v1/latest?base=USD&symbols=IDR';

  Future<ExchangeRate> fetchExchangeRate() async {
    final response = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ExchangeRate.fromJson(data);
    }

    throw Exception(
      'Failed to load exchange rate. '
      'Status code: ${response.statusCode}',
    );
  }
}
