import 'package:flutter/material.dart';
import 'package:spndly_original/theme/app_theme.dart';

enum TransactionType { expense, income }

enum Category { food, transport, entertainment, health, other }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final Category category;
  final DateTime date;
  final String? note;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
  });

  String get formattedAmount {
    final sign = type == TransactionType.expense ? '−' : '+';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  Color get amountColor =>
      type == TransactionType.expense ? AppColors.danger : AppColors.income;

  double get signedAmount => type == TransactionType.expense ? -amount : amount;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'type': type.name,
    'category': category.name,
    'date': date.toIso8601String(),
    'note': note,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as String,
    title: json['title'] as String,
    amount: (json['amount'] as num).toDouble(),
    type: TransactionType.values.byName(json['type'] as String),
    category: Category.values.byName(json['category'] as String),
    date: DateTime.parse(json['date'] as String),
    note: json['note'] as String?,
  );
}

extension CategoryUI on Category {
  String get label {
    switch (this) {
      case Category.food:
        return 'Food';
      case Category.transport:
        return 'Transport';
      case Category.entertainment:
        return 'Entertainment';
      case Category.health:
        return 'Health';
      case Category.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case Category.food:
        return Icons.shopping_cart_rounded;
      case Category.transport:
        return Icons.directions_car_rounded;
      case Category.entertainment:
        return Icons.movie_rounded;
      case Category.health:
        return Icons.favorite_rounded;
      case Category.other:
        return Icons.category_rounded;
    }
  }

  Color get bgColor {
    switch (this) {
      case Category.food:
        return AppColors.catFood;
      case Category.transport:
        return AppColors.catTransport;
      case Category.entertainment:
        return AppColors.catEntertainment;
      case Category.health:
        return AppColors.catHealth;
      case Category.other:
        return AppColors.catOther;
    }
  }
}
