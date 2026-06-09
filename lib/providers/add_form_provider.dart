import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spndly_original/models/transaction.dart';

class AddFormState {
  final TransactionType type;
  final Category category;
  final DateTime date;

  const AddFormState({
    this.type = TransactionType.expense,
    this.category = Category.food,
    required this.date,
  });

  AddFormState copyWith({
    TransactionType? type,
    Category? category,
    DateTime? date,
  }) => AddFormState(
    type: type ?? this.type,
    category: category ?? this.category,
    date: date ?? this.date,
  );
}

class AddFormNotifier extends StateNotifier<AddFormState> {
  AddFormNotifier() : super(AddFormState(date: DateTime.now()));

  void setType(TransactionType t) => state = state.copyWith(type: t);
  void setCategory(Category c) => state = state.copyWith(category: c);
  void setDate(DateTime d) => state = state.copyWith(date: d);
  void reset() => state = AddFormState(date: DateTime.now());
}

final addFormProvider =
    StateNotifierProvider.autoDispose<AddFormNotifier, AddFormState>(
      (ref) => AddFormNotifier(),
    );
