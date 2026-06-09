import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:spndly_original/models/transaction.dart';
import 'package:spndly_original/providers/add_form_provider.dart';
import 'package:spndly_original/providers/transactions_provider.dart';
import 'package:spndly_original/theme/app_theme.dart';
import 'package:spndly_original/utils/formatters.dart';

class AddPage extends ConsumerStatefulWidget {
  const AddPage({super.key});

  @override
  ConsumerState<AddPage> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final form = ref.read(addFormProvider);

    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty) {
      _showError('Please enter a title');
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    final tx = Transaction(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      type: form.type,
      category: form.category,
      date: form.date,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    await ref.read(transactionsProvider.notifier).add(tx);
    ref.read(addFormProvider.notifier).reset();

    if (mounted) Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(addFormProvider);

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'New\nTransaction',
                    style: AppText.serif(28, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: TransactionType.values.map((t) {
                        final selected = form.type == t;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                ref.read(addFormProvider.notifier).setType(t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selected
                                    ? (t == TransactionType.expense
                                          ? AppColors.danger
                                          : AppColors.income)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                t.name[0].toUpperCase() + t.name.substring(1),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.35),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'AMOUNT',
                    style: AppText.tiny.copyWith(
                      color: Colors.white.withOpacity(0.35),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: AppText.serif(36, color: Colors.white),
                    cursorColor: AppColors.accent,
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      prefixStyle: AppText.serif(
                        20,
                        color: Colors.white.withOpacity(0.40),
                      ),
                      hintText: '0.00',
                      hintStyle: AppText.serif(
                        36,
                        color: Colors.white.withOpacity(0.20),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: const BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      _FieldLabel('Title'),
                      const SizedBox(height: 6),
                      _InputBox(
                        child: TextField(
                          controller: _titleController,
                          style: AppText.body,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Grocery run',
                            hintStyle: TextStyle(color: AppColors.muted),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      _FieldLabel('Category'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: Category.values.map((c) {
                          final selected = form.category == c;
                          return GestureDetector(
                            onTap: () => ref
                                .read(addFormProvider.notifier)
                                .setCategory(c),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.ink
                                    : AppColors.paperDark,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.ink
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                c.label,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? AppColors.accent
                                      : AppColors.muted,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      _FieldLabel('Date'),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: form.date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            builder: (context, child) => Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.ink,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            ref.read(addFormProvider.notifier).setDate(picked);
                          }
                        },
                        child: _InputBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(shortDate(form.date), style: AppText.body),
                              const Icon(
                                Icons.calendar_month_rounded,
                                size: 18,
                                color: AppColors.muted,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Note (optional)
                      _FieldLabel('Note (optional)'),
                      const SizedBox(height: 6),
                      _InputBox(
                        child: TextField(
                          controller: _noteController,
                          style: AppText.body,
                          decoration: const InputDecoration(
                            hintText: 'Add a note...',
                            hintStyle: TextStyle(color: AppColors.muted),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Save button
                      GestureDetector(
                        onTap: _save,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.ink,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save Transaction',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_rounded,
                                color: AppColors.accent,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppText.tiny.copyWith(color: AppColors.muted, letterSpacing: 0.8),
    );
  }
}

class _InputBox extends StatelessWidget {
  final Widget child;
  const _InputBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.paperDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: child,
    );
  }
}
