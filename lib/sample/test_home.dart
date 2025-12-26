import 'package:flutter/material.dart';
import 'package:my_sivi/sample/tab_one.dart';
import 'package:my_sivi/sample/tab_two.dart';

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: const Text("Home Screen"),
                floating: true,
                snap: true,
                pinned: false,
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "Tab One"),
                    Tab(text: "Tab Two"),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              TabOneScreen(),
              TabTwoScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
