import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sivi/core/models/user_model.dart';
import 'package:my_sivi/features/chat/chat_cubit.dart';

import '../../features/chat/chat_page.dart';

class AppNavigator {
  static void openChat(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ChatCubit(),
          child: ChatPage(user: user),
        ),
      ),
    );
  }
}
