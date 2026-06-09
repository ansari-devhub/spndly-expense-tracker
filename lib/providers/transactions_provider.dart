import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spndly_original/models/transaction.dart';

const _kKey = 'spndly_transactions';

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  TransactionsNotifier() : super([]) {
    _load(); // load from disk when app starts
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null) return;

    final List decoded = jsonDecode(raw);
    state = decoded.map((e) => Transaction.fromJson(e)).toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kKey,
      jsonEncode(state.map((t) => t.toJson()).toList()),
    );
  }

  Future<void> add(Transaction t) async {
    state = [t, ...state]; // newest first
    await _save();
  }

  Future<void> delete(String id) async {
    state = state.where((t) => t.id != id).toList();
    await _save();
  }
}

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<Transaction>>(
      (ref) => TransactionsNotifier(),
    );

final balanceProvider = Provider<double>((ref) {
  return ref
      .watch(transactionsProvider)
      .fold(0.0, (sum, t) => sum + t.signedAmount);
});

final monthlyIncomeProvider = Provider<double>((ref) {
  final now = DateTime.now();
  return ref
      .watch(transactionsProvider)
      .where(
        (t) =>
            t.type == TransactionType.income &&
            t.date.month == now.month &&
            t.date.year == now.year,
      )
      .fold(0.0, (sum, t) => sum + t.amount);
});

final monthlyExpenseProvider = Provider<double>((ref) {
  final now = DateTime.now();
  return ref
      .watch(transactionsProvider)
      .where(
        (t) =>
            t.type == TransactionType.expense &&
            t.date.month == now.month &&
            t.date.year == now.year,
      )
      .fold(0.0, (sum, t) => sum + t.amount);
});

final recentProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(transactionsProvider).take(5).toList();
});

final categoryBreakdownProvider = Provider<Map<Category, double>>((ref) {
  final now = DateTime.now();
  final expenses = ref
      .watch(transactionsProvider)
      .where(
        (t) =>
            t.type == TransactionType.expense &&
            t.date.month == now.month &&
            t.date.year == now.year,
      );

  final map = <Category, double>{};
  for (final t in expenses) {
    map[t.category] = (map[t.category] ?? 0) + t.amount;
  }
  return map;
});

typedef MonthData = ({String month, double income, double expense});

final monthlyChartProvider = Provider<List<MonthData>>((ref) {
  final all = ref.watch(transactionsProvider);
  final now = DateTime.now();

  return List.generate(6, (i) {
    final d = DateTime(now.year, now.month - (5 - i), 1);

    final income = all
        .where(
          (t) =>
              t.type == TransactionType.income &&
              t.date.month == d.month &&
              t.date.year == d.year,
        )
        .fold(0.0, (s, t) => s + t.amount);

    final expense = all
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.date.month == d.month &&
              t.date.year == d.year,
        )
        .fold(0.0, (s, t) => s + t.amount);

    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return (month: m[d.month - 1], income: income, expense: expense);
  });
});
