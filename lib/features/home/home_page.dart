import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../shared_widgets/appbar_switcher.dart';
import 'home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.appTitle),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppBarSwitcher(
                    selectedIndex: selectedIndex,
                    onChanged: context.read<HomeCubit>().changeTab,
                  ),
                ),
              ),
            ),
            body: Center(
              child: Text(
                selectedIndex == 0
                    ? AppStrings.usersPlaceholder
                    : AppStrings.historyPlaceholder,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}