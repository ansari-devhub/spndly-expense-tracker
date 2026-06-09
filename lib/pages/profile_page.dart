import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spndly_original/providers/transactions_provider.dart';
import 'package:spndly_original/theme/app_theme.dart';
import 'package:spndly_original/utils/formatters.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final allTx = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.ink,
                child: Text(
                  'AN',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Ansari', style: AppText.serif(22)),
              Text('Personal Finance', style: AppText.small),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Balance',
                      value: currency(balance),
                      color: balance >= 0 ? AppColors.income : AppColors.danger,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Transactions',
                      value: '${allTx.length}',
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _SettingsTile(
                icon: Icons.notifications_rounded,
                label: 'Notifications',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.attach_money_rounded,
                label: 'Currency',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.color_lens_rounded,
                label: 'Appearance',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.shield_rounded,
                label: 'Privacy',
                onTap: () {},
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => _confirmClearAll(context, ref),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.danger),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Clear all data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(
          'This will permanently delete all your transactions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Delete all one by one
              final ids = ref
                  .read(transactionsProvider)
                  .map((t) => t.id)
                  .toList();
              for (final id in ids) {
                ref.read(transactionsProvider.notifier).delete(id);
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.small),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.paperDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 17, color: AppColors.ink),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppText.body)),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
