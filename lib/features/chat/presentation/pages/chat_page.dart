import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sivi/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:my_sivi/features/users/data/models/user_model.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
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
      appBar: _renderAppBar(),
      body: _renderBody(),
    );
  }

  PreferredSizeWidget _renderAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      title: _renderAppBarTitle(),
    );
  }

  Widget _renderAppBarTitle() {
    return Row(
      children: [
        _renderUserAvatar(),
        const SizedBox(width: 12),
        _renderUserDetails(),
      ],
    );
  }

  Widget _renderUserAvatar() {
    return CircleAvatar(
      radius: 18,
      backgroundImage: widget.user.imageUrl.isNotEmpty
          ? NetworkImage(widget.user.imageUrl)
          : null,
      child: widget.user.imageUrl.isEmpty ? Text(widget.user.initials) : null,
    );
  }

  Widget _renderUserDetails() {
    return Column(
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
          AppStrings.onlineStatus,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.onlineStatus,
          ),
        ),
      ],
    );
  }

  Widget _renderBody() {
    return Column(
      children: [
        _renderMessages(),
        _renderInputBar(),
      ],
    );
  }

  Widget _renderMessages() {
    return Expanded(
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          return _renderChatState(state);
        },
      ),
    );
  }

  Widget _renderChatState(ChatState state) {
    if (state is ChatLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ChatLoaded) {
      return _renderMessageList(state);
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
  }

  Widget _renderMessageList(ChatLoaded state) {
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

  Widget _renderInputBar() {
    return ChatInputBar(
      onSend: context.read<ChatCubit>().sendMessage,
    );
  }
}
