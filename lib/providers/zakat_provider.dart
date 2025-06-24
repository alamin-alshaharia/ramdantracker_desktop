import 'package:flutter_riverpod/flutter_riverpod.dart';

class ZakatState {
  final String currency;
  final double goldRate;
  final double silverRate;
  final double assets;
  final double debts;
  final double other;
  final double? result;
  final String? error;
  const ZakatState({
    required this.currency,
    required this.goldRate,
    required this.silverRate,
    required this.assets,
    required this.debts,
    required this.other,
    this.result,
    this.error,
  });

  ZakatState copyWith({
    String? currency,
    double? goldRate,
    double? silverRate,
    double? assets,
    double? debts,
    double? other,
    double? result,
    String? error,
  }) {
    return ZakatState(
      currency: currency ?? this.currency,
      goldRate: goldRate ?? this.goldRate,
      silverRate: silverRate ?? this.silverRate,
      assets: assets ?? this.assets,
      debts: debts ?? this.debts,
      other: other ?? this.other,
      result: result ?? this.result,
      error: error,
    );
  }
}

class ZakatNotifier extends StateNotifier<ZakatState> {
  ZakatNotifier()
      : super(const ZakatState(
          currency: 'USD',
          goldRate: 60.0,
          silverRate: 0.8,
          assets: 0.0,
          debts: 0.0,
          other: 0.0,
          result: null,
        ));

  void setCurrency(String currency) => state = state.copyWith(currency: currency, error: null);
  void setGoldRate(double rate) => state = state.copyWith(goldRate: rate, error: null);
  void setSilverRate(double rate) => state = state.copyWith(silverRate: rate, error: null);
  void setAssets(double value) => state = state.copyWith(assets: value, error: null);
  void setDebts(double value) => state = state.copyWith(debts: value, error: null);
  void setOther(double value) => state = state.copyWith(other: value, error: null);

  void calculate() {
    try {
      // Simple mock logic: Zakat = 2.5% of (assets + other - debts)
      final base = state.assets + state.other - state.debts;
      final zakat = base > 0 ? base * 0.025 : 0.0;
      state = state.copyWith(result: zakat, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> reload() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      calculate();
      state = state.copyWith(error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final zakatProvider = StateNotifierProvider<ZakatNotifier, ZakatState>(
  (ref) => ZakatNotifier(),
); 