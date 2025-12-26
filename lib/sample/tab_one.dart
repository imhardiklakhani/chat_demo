import 'package:flutter/material.dart';

class TabOneScreen extends StatefulWidget {
  const TabOneScreen({super.key});

  @override
  State<TabOneScreen> createState() => _TabOneScreenState();
}

class _TabOneScreenState extends State<TabOneScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
      key: const PageStorageKey("tab_one_list"),
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Tab One Item ${index + 1}"),
        );
      },
    );
  }
}
