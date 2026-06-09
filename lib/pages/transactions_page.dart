import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:spndly_original/models/transaction.dart';
import 'package:spndly_original/providers/transactions_provider.dart';
import 'package:spndly_original/theme/app_theme.dart';
import 'package:spndly_original/utils/formatters.dart';
import 'package:spndly_original/widgets/transaction_tile.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('All Transactions', style: AppText.serif(24)),
              Text(monthYear(DateTime.now()), style: AppText.small),
              const SizedBox(height: 16),

              if (all.isEmpty)
                const Expanded(
                  child: Center(child: Text('No transactions yet 💸')),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: all.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => TransactionTile(
                      tx: all[i],
                      onDelete: () => ref
                          .read(transactionsProvider.notifier)
                          .delete(all[i].id),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
