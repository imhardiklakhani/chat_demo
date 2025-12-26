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
                  color:
                      isSender ? AppColors.senderBubble : AppColors.receiverBubble,
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
    final words = text.split(' ');

    return Wrap(
      children: words.map((word) {
        return GestureDetector(
          onLongPress: () {
            final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');

            if (cleanWord.isEmpty) return;

            context.read<DictionaryCubit>().lookupWord(cleanWord);

            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              builder: (sheetContext) {
                return BlocProvider.value(
                  value: context.read<DictionaryCubit>(),
                  child: const WordMeaningBottomSheet(),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 4),
            child: Text(
              '$word ',
              style: TextStyle(
                fontSize: 16,
                color: isSender
                    ? AppColors.senderTextColor
                    : AppColors.receiverTextColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
