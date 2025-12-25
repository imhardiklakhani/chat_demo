import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sivi/features/history/data/repository/history_repository.dart';
import 'package:my_sivi/features/history/presentation/cubit/history_cubit.dart';
import 'package:my_sivi/features/history/presentation/history_page.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared_widgets/appbar_switcher.dart';
import '../users/users_cubit.dart';
import '../users/users_page.dart';
import 'home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showAddUserDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.addUser),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter user name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              context.read<UsersCubit>().addLocalUser(name);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${AppStrings.userAdded}: $name'),
                ),
              );
            },
            child: const Text(AppStrings.addUser),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => UsersCubit()..loadUsers()),
        BlocProvider(
          create: (_) => HistoryCubit(HistoryRepository())..loadHistory(),
        ),
      ],
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, selectedIndex) {
          return SafeArea(
            child: Scaffold(
              floatingActionButton: selectedIndex == 0
                  ? FloatingActionButton(
                      backgroundColor: AppColors.fabBackground,
                      onPressed: () => _showAddUserDialog(context),
                      child: const Icon(Icons.add, color: AppColors.fabIcon),
                    )
                  : null,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      scrolledUnderElevation: 0,
                      elevation: 0,
                      floating: true,
                      snap: true,
                      pinned: false,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppBarSwitcher(
                            selectedIndex: selectedIndex,
                            onChanged: context.read<HomeCubit>().changeTab,
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: IndexedStack(
                  index: selectedIndex,
                  children: const [
                    UsersPage(),
                    HistoryPage(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
