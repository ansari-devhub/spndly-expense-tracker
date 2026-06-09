import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spndly_original/pages/add_page.dart';
import 'package:spndly_original/pages/analytics_page.dart';
import 'package:spndly_original/pages/home_page.dart';
import 'package:spndly_original/pages/profile_page.dart';
import 'package:spndly_original/pages/transactions_page.dart';
import 'package:spndly_original/theme/app_theme.dart';

final navIndexProvider = StateProvider<int>((ref) => 0);

class MainNav extends ConsumerWidget {
  const MainNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);

    final pages = [
      HomePage(
        onAddTap: () => _openAdd(context),
        onSeeAllTap: () => ref.read(navIndexProvider.notifier).state = 1,
      ),
      const TransactionsPage(),
      const AnalyticsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: _BottomNav(
        currentIndex: index,
        onTap: (i) => ref.read(navIndexProvider.notifier).state = i,
      ),
    );
  }

  void _openAdd(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPage()));
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.paper,
        selectedItemColor: AppColors.ink,
        unselectedItemColor: AppColors.muted,
        selectedLabelStyle: AppText.tiny.copyWith(color: AppColors.ink),
        unselectedLabelStyle: AppText.tiny,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
