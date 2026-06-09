import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spndly_original/models/transaction.dart';
import 'package:spndly_original/providers/transactions_provider.dart';
import 'package:spndly_original/theme/app_theme.dart';
import 'package:spndly_original/utils/formatters.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartData = ref.watch(monthlyChartProvider);
    final breakdown = ref.watch(categoryBreakdownProvider);
    final totalExpense = ref.watch(monthlyExpenseProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Analytics', style: AppText.serif(24)),
              Text('Your spending breakdown', style: AppText.small),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Income vs Expenses',
                          style: AppText.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            _LegendDot(color: AppColors.ink, label: 'Exp'),
                            const SizedBox(width: 10),
                            _LegendDot(color: AppColors.accent, label: 'Inc'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 110,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: chartData.map((m) {
                          final maxVal = chartData
                              .expand((d) => [d.income, d.expense])
                              .reduce((a, b) => a > b ? a : b);
                          final maxHeight = 90.0;
                          final incH = maxVal == 0
                              ? 4.0
                              : (m.income / maxVal * maxHeight).clamp(
                                  4.0,
                                  maxHeight,
                                );
                          final expH = maxVal == 0
                              ? 4.0
                              : (m.expense / maxVal * maxHeight).clamp(
                                  4.0,
                                  maxHeight,
                                );

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 10,
                                    height: expH,
                                    decoration: BoxDecoration(
                                      color: AppColors.ink,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Container(
                                    width: 10,
                                    height: incH,
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(m.month, style: AppText.tiny),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text('By Category', style: AppText.serif(20)),
              const SizedBox(height: 12),

              if (breakdown.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('No expenses this month', style: AppText.small),
                  ),
                )
              else
                ...Category.values.where((c) => breakdown.containsKey(c)).map((
                  c,
                ) {
                  final amount = breakdown[c]!;
                  final pct = totalExpense == 0
                      ? 0.0
                      : (amount / totalExpense).clamp(0.0, 1.0);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: c.bgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(c.icon, size: 18, color: AppColors.ink),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.label, style: AppText.body),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 5,
                                    backgroundColor: AppColors.paperDark,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(currency(amount), style: AppText.bodyBold),
                              Text(
                                '${(pct * 100).toStringAsFixed(0)}%',
                                style: AppText.small,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppText.small),
      ],
    );
  }
}
