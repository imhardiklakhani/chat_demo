import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../users/presentation/cubit/users_cubit.dart';
import '../../../history/presentation/cubit/history_cubit.dart';
import '../../../history/data/repository/history_repository.dart';

class AppShellPage extends StatefulWidget {
  const AppShellPage({super.key});

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UsersCubit()..loadUsers()),
        BlocProvider(
          create: (_) => HistoryCubit(HistoryRepository())..loadHistory(),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            HomePage(),
            Center(child: Text(AppStrings.others)),
            Center(child: Text(AppStrings.settings)),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.bottomBarBackground,
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.bottomBarSelected,
          unselectedItemColor: AppColors.bottomBarUnselected,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              label: AppStrings.others,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppStrings.settings,
            ),
          ],
        ),
      ),
    );
  }
}