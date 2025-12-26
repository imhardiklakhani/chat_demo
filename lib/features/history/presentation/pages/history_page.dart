import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../users/data/models/user_model.dart';
import '../cubit/history_cubit.dart';
import '../cubit/history_state.dart';

class HistoryPage extends StatefulWidget {
  final void Function(ScrollDirection direction) onUserScroll;

  const HistoryPage({
    super.key,
    required this.onUserScroll,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        widget.onUserScroll(notification.direction);
        return false;
      },
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading || state is HistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HistoryError) {
            return Center(child: Text(state.message));
          }

          final items = (state as HistorySuccess).items;

          return ListView.builder(
            key: const PageStorageKey('history_list'),
            controller: _controller,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              final parts = item.fullName.split(' ');
              final user = UserModel(
                id: index,
                firstName: parts.first,
                lastName:
                parts.length > 1 ? parts.sublist(1).join(' ') : '',
                imageUrl: item.avatarUrl,
                isOnline: true,
                lastActive: item.timeLabel,
              );

              return ListTile(
                onTap: () => AppNavigator.openChat(context, user),
                leading:
                CircleAvatar(backgroundImage: NetworkImage(item.avatarUrl)),
                title: Text(item.fullName),
                subtitle: Text(item.lastMessage),
              );
            },
          );
        },
      ),
    );
  }
}