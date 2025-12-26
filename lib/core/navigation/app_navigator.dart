import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sivi/core/network/api_client.dart';
import 'package:my_sivi/features/chat/data/repository/dictionary_repository.dart';
import 'package:my_sivi/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:my_sivi/features/chat/presentation/cubit/dictionary_cubit.dart';
import 'package:my_sivi/features/chat/presentation/pages/chat_page.dart';
import 'package:my_sivi/features/users/data/models/user_model.dart';

class AppNavigator {
  static void openChat(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ChatCubit(),
            ),
            BlocProvider(
              create: (_) => DictionaryCubit(
                DictionaryRepository(ApiClient()),
              ),
            ),
          ],
          child: ChatPage(user: user),
        ),
      ),
    );
  }
}
