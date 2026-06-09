import 'package:flutter/material.dart';
import 'package:spndly_original/models/transaction.dart';
import 'package:spndly_original/theme/app_theme.dart';
import 'package:spndly_original/utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final Transaction tx;
  final VoidCallback? onDelete;

  const TransactionTile({super.key, required this.tx, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 4,
          ),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tx.category.bgColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(tx.category.icon, size: 20, color: AppColors.ink),
          ),
          title: Text(tx.title, style: AppText.bodyBold),
          subtitle: Text(
            '${relativeDate(tx.date)} · ${tx.category.label}',
            style: AppText.small,
          ),
          trailing: Text(
            tx.formattedAmount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: tx.amountColor,
            ),
          ),
        ),
      ),
    );
  }
}
