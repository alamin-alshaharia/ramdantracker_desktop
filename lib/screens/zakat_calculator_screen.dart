import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/zakat_provider.dart';
import 'app_error_widget.dart';

class ZakatCalculatorScreen extends ConsumerWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final zakat = ref.watch(zakatProvider);
    final notifier = ref.read(zakatProvider.notifier);
    final currencyItems = const [
      DropdownMenuItem(value: 'USD', child: Text('USD')),
      DropdownMenuItem(value: 'EUR', child: Text('EUR')),
      DropdownMenuItem(value: 'SAR', child: Text('SAR')),
    ];
    if (zakat.error != null) {
      return AppErrorWidget(
        message: 'Failed to load Zakat calculator.',
        details: zakat.error,
        onRetry: notifier.reload,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calculate, color: theme.colorScheme.primary, size: 32),
                const SizedBox(width: 12),
                Text('Zakat Calculator', style: theme.textTheme.headlineLarge),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: zakat.currency,
                            decoration: const InputDecoration(
                              labelText: 'Currency',
                              border: OutlineInputBorder(),
                            ),
                            items: currencyItems,
                            onChanged: (v) => notifier.setCurrency(v!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: zakat.goldRate.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Gold Rate (per gram)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.setGoldRate(double.tryParse(v) ?? 0.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: zakat.silverRate.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Silver Rate (per gram)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.setSilverRate(double.tryParse(v) ?? 0.0),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: zakat.assets.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Total Assets',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.setAssets(double.tryParse(v) ?? 0.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: zakat.debts.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Total Debts',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.setDebts(double.tryParse(v) ?? 0.0),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: zakat.other.toString(),
                            decoration: const InputDecoration(
                              labelText: 'Other Zakatable Items',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.setOther(double.tryParse(v) ?? 0.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: notifier.calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Calculate Zakat',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Zakat:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            zakat.result == null
                                ? 'Result will appear here.'
                                : '${zakat.result!.toStringAsFixed(2)} ${zakat.currency}',
                            style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 