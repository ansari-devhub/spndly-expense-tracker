import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spndly_original/providers/transactions_provider.dart';
import 'package:spndly_original/theme/app_theme.dart';
import 'package:spndly_original/utils/formatters.dart';
import 'package:spndly_original/widgets/transaction_tile.dart';

class HomePage extends ConsumerWidget {
  final VoidCallback onAddTap;
  final VoidCallback onSeeAllTap;

  const HomePage({
    super.key,
    required this.onAddTap,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentProvider);
    final balance = ref.watch(balanceProvider);
    final inc = ref.watch(monthlyIncomeProvider);
    final exp = ref.watch(monthlyExpenseProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning,',
                        style: AppText.small.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text('Ansari 👋', style: AppText.serif(22)),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.ink,
                    child: Text(
                      'AN',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: 50,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.06),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL BALANCE',
                          style: AppText.tiny.copyWith(
                            color: Colors.white.withOpacity(0.45),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currency(balance),
                          style: AppText.serif(38, color: Colors.white),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            _CardStat(
                              icon: Icons.arrow_upward_rounded,
                              label: 'INCOME',
                              value: currency(inc),
                              iconColor: AppColors.accent,
                            ),
                            const SizedBox(width: 28),
                            _CardStat(
                              icon: Icons.arrow_downward_rounded,
                              label: 'EXPENSES',
                              value: currency(exp),
                              iconColor: AppColors.danger,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickAction(
                    icon: Icons.add_rounded,
                    label: 'Add',
                    onTap: onAddTap,
                  ),
                  _QuickAction(
                    icon: Icons.bar_chart_rounded,
                    label: 'Stats',
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.bookmark_rounded,
                    label: 'Budget',
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent', style: AppText.serif(20)),
                  GestureDetector(
                    onTap: onSeeAllTap,
                    child: Row(
                      children: [
                        Text(
                          'See all',
                          style: AppText.small.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: AppColors.muted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (recent.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        const Text('💸', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text('No transactions yet', style: AppText.body),
                        const SizedBox(height: 4),
                        Text(
                          'Tap Add to record your first one',
                          style: AppText.small,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recent.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => TransactionTile(
                    tx: recent[i],
                    onDelete: () => ref
                        .read(transactionsProvider.notifier)
                        .delete(recent[i].id),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _CardStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 12),
            const SizedBox(width: 3),
            Text(
              label,
              style: AppText.tiny.copyWith(
                color: Colors.white.withOpacity(0.40),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.paperDark,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: Icon(icon, color: AppColors.ink, size: 22),
          ),
          const SizedBox(height: 7),
          Text(label.toUpperCase(), style: AppText.tiny),
        ],
      ),
    );
  }
}
