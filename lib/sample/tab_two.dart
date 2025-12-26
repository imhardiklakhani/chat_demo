import 'package:flutter/material.dart';

class TabTwoScreen extends StatefulWidget {
  const TabTwoScreen({super.key});

  @override
  State<TabTwoScreen> createState() => _TabTwoScreenState();
}

class _TabTwoScreenState extends State<TabTwoScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
      key: const PageStorageKey("tab_two_list"),
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Tab Two Item ${index + 1}"),
        );
      },
    );
  }
}
