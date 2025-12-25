import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sivi/core/models/user_model.dart';
import 'package:my_sivi/core/navigation/app_navigator.dart';

import '../data/models/history_item_model.dart';
import 'cubit/history_cubit.dart';
import 'cubit/history_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryInitial) {
          context.read<HistoryCubit>().loadHistory();
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HistoryError) {
          return Center(child: Text(state.message));
        }

        if (state is HistorySuccess) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text('No chats yet'),
            );
          }

          return ListView.builder(
            key: const PageStorageKey('history_list'),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final HistoryItemModel item = state.items[index];

              return ListTile(
                onTap: () {
                  final parts = item.fullName.split(' ');
                  final firstName = parts.first;
                  final lastName =
                      parts.length > 1 ? parts.sublist(1).join(' ') : '';

                  final user = UserModel(
                    id: index,
                    // or item-based id if you stored it
                    firstName: firstName,
                    lastName: lastName,
                    imageUrl: item.avatarUrl,
                    isOnline: true,
                    lastActive: item.timeLabel,
                  );
                  AppNavigator.openChat(context, user);
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(item.avatarUrl),
                ),
                title: Text(
                  item.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  item.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.timeLabel,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    if (item.unreadCount > 0)
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.green,
                        child: Text(
                          item.unreadCount.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
