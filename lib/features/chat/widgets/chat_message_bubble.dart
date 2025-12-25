import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../chat_message_model.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSender
                    ? AppColors.senderBubble
                    : AppColors.receiverBubble,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          if (isSender) _avatar(context, isSender, 'Y'),
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
}
