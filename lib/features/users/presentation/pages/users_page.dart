import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../data/models/user_model.dart';
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



  void _showAddUserDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add User'),
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


              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_controller.hasClients) {
                  _controller.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User added: $name')),
              );
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }


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
      child: _renderBody(),
    );
  }

  Widget _renderBody() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading || state is UsersInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsersError) {
            return Center(child: Text(state.message));
          }

          final users = (state as UsersSuccess).users;
          return _renderUserList(users);
        },
      ),
    );
  }

  Widget _renderUserList(List<UserModel> users) {
    return ListView.builder(
      key: const PageStorageKey(AppStrings.usersListStorageKey),
      controller: _controller,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _renderUserTile(user);
      },
    );
  }

  Widget _renderUserTile(UserModel user) {
    return ListTile(
      onTap: () => AppNavigator.openChat(context, user),
      leading: CircleAvatar(
        backgroundImage:
            user.imageUrl.isNotEmpty ? NetworkImage(user.imageUrl) : null,
        child: user.imageUrl.isEmpty ? Text(user.initials) : null,
      ),
      title: Text(user.fullName),
      subtitle: Text(user.lastActive),
    );
  }
}
