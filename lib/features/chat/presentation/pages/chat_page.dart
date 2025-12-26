import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sivi/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:my_sivi/features/chat/presentation/cubit/dictionary_cubit.dart';
import 'package:my_sivi/features/chat/presentation/cubit/dictionary_state.dart';
import 'package:my_sivi/features/users/data/models/user_model.dart';

import '../cubit/chat_state.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_bubble.dart';

class ChatPage extends StatefulWidget {
  final UserModel user;

  const ChatPage({
    super.key,
    required this.user,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  StreamSubscription? _receiverSub;
  StreamSubscription? _errorSub;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<ChatCubit>();

    // initial receiver message (ID = 1)
    cubit.loadInitialReceiver();

    // listen to receiver stream (reactive)
    _receiverSub = cubit.receiverStream.listen((_) {
      _scrollToBottom();
    });

    _errorSub = cubit.errorStream.listen((message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      });
    });
  }

  @override
  void dispose() {
    _receiverSub?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.user.imageUrl.isNotEmpty
                  ? NetworkImage(widget.user.imageUrl)
                  : null,
              child: widget.user.imageUrl.isEmpty
                  ? Text(widget.user.initials)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.user.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return ChatMessageBubble(
                        message: state.messages[index],
                        userInitials: widget.user.imageUrl,
                      );
                    },
                  );
                }
                if (state is ChatError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  });
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          ChatInputBar(
            onSend: context.read<ChatCubit>().sendMessage,
          ),
        ],
      ),
    );
  }
}