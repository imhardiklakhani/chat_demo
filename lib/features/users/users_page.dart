import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/models/user_model.dart';
import 'users_cubit.dart';
import 'users_state.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading || state is UsersInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UsersError) {
          return Center(child: Text(state.message));
        }

        if (state is UsersSuccess) {
          final users = state.users;

          return ListView.builder(
            key: const PageStorageKey('users_list'),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: user.imageUrl.isNotEmpty
                          ? NetworkImage(user.imageUrl)
                          : null,
                      child: user.imageUrl.isEmpty
                          ? Text(user.initials)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: user.isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(user.fullName),
                subtitle: Text(user.lastActive),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}