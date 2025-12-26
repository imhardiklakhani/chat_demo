import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../shared_widgets/appbar_switcher.dart';
import '../../../users/presentation/cubit/users_cubit.dart';
import '../../../users/presentation/pages/users_page.dart';
import '../../../history/presentation/cubit/history_cubit.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../history/data/repository/history_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _showTabs = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onScrollDirection(ScrollDirection direction) {
    if (direction == ScrollDirection.reverse && _showTabs) {
      setState(() => _showTabs = false);
    } else if (direction == ScrollDirection.forward && !_showTabs) {
      setState(() => _showTabs = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UsersCubit()..loadUsers()),
        BlocProvider(
          create: (_) => HistoryCubit(HistoryRepository())..loadHistory(),
        ),
      ],
      child: SafeArea(
        child: Column(
          children: [
            // App Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.appTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Animated Tabs
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: _showTabs ? 48 : 0,
              child: ClipRect(
                child: AppBarSwitcher(
                  selectedIndex: _tabController.index,
                  onChanged: (i) => _tabController.animateTo(i),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: IndexedStack(
                index: _tabController.index,
                children: [
                  UsersPage(
                    onUserScroll: _onScrollDirection,
                  ),
                  HistoryPage(
                    onUserScroll: _onScrollDirection,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}