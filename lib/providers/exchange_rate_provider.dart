
import 'package:flutter/material.dart';

import '../models/exchange_rate.dart';
import '../repositories/exchange_rate_repository.dart';

class ExchangeRateProvider extends ChangeNotifier {
  final ExchangeRateRepository _repository =
      ExchangeRateRepository();

  ExchangeRate? _exchangeRate;
  bool _isLoading = false;
  String? _errorMessage;

  ExchangeRate? get exchangeRate => _exchangeRate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadExchangeRate() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _exchangeRate = await _repository.getExchangeRate();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
