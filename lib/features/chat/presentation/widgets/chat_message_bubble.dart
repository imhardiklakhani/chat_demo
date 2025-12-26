import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sivi/features/chat/presentation/cubit/dictionary_cubit.dart';
import 'package:my_sivi/features/chat/presentation/widgets/word_meaning_bottom_sheet.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/chat_message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String userInitials;

  const ChatMessageBubble(
      {super.key, required this.message, required this.userInitials});

  @override
  Widget build(BuildContext context) {
    final isSender = message.isSender;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSender) _avatar(context, isSender, userInitials),
          Flexible(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSender
                      ? AppColors.senderBubble
                      : AppColors.receiverBubble,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: buildMessageText(context, message.text, isSender)),
          ),
          if (isSender)
            _avatar(context, isSender, AppStrings.currentUserInitial),
        ],
      ),
    );
  }

  Widget _avatar(BuildContext context, bool isSender, String initials) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: CircleAvatar(
          radius: 14,
          backgroundImage: !isSender ? NetworkImage(initials) : null,
          child: isSender ? Text(initials) : null),
    );
  }

  Widget buildMessageText(BuildContext context, String text, bool isSender) {
    return SelectableText(
      text,
      style: TextStyle(
        fontSize: 16,
        color:
            isSender ? AppColors.senderTextColor : AppColors.receiverTextColor,
      ),
      onSelectionChanged: (selection, cause) async {
        if (cause != SelectionChangedCause.longPress) return;

        final selectedWord = selection.textInside(text).trim();
        if (selectedWord.isEmpty) return;

        context.read<DictionaryCubit>().lookupWord(selectedWord);
        await Future.delayed(const Duration(milliseconds: 1000));
        await showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => BlocProvider.value(
            value: context.read<DictionaryCubit>(),
            child: const WordMeaningBottomSheet(),
          ),
        );
      },
    );
  }
}
