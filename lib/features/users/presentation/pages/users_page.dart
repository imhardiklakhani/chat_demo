import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';

class UsersPage extends StatefulWidget {
  final void Function(ScrollDirection direction) onUserScroll;

  const UsersPage({
    super.key,
    required this.onUserScroll,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage>
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
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading || state is UsersInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsersError) {
            return Center(child: Text(state.message));
          }

          final users = (state as UsersSuccess).users;

          return ListView.builder(
            key: const PageStorageKey('users_list'),
            controller: _controller,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return ListTile(
                onTap: () => AppNavigator.openChat(context, user),
                leading: CircleAvatar(
                  backgroundImage: user.imageUrl.isNotEmpty
                      ? NetworkImage(user.imageUrl)
                      : null,
                  child:
                  user.imageUrl.isEmpty ? Text(user.initials) : null,
                ),
                title: Text(user.fullName),
                subtitle: Text(user.lastActive),
              );
            },
          );
        },
      ),
    );
  }
}