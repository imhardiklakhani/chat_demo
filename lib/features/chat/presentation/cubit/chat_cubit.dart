import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sivi/core/network/api_constants.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/chat_message_model.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatInitial());

  final List<ChatMessage> _messages = [];

  // Stream for receiver messages (reactive)
  final StreamController<ChatMessage> _receiverController =
      StreamController<ChatMessage>.broadcast();

// Stream for catching errors
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  Stream<String> get errorStream => _errorController.stream;

  Stream<ChatMessage> get receiverStream => _receiverController.stream;

  int _commentId = 1;
  bool _retrying = false;

  /// Call on chat open
  Future<void> loadInitialReceiver() async {
    emit(const ChatLoading());
    await _fetchReceiverAndEmit();
  }

  /// Call on Send
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Sender message (state-based)
    _messages.add(ChatMessage(text: text.trim(), isSender: true));
    emit(ChatLoaded(List.from(_messages)));

    // Next receiver
    _incrementId();
    _fetchReceiverAndEmit();
  }

  Future<void> _fetchReceiverAndEmit() async {
    try {
      final response = await ApiClient.get(
        '${ApiConstants.baseUrl}/comments/$_commentId',
      );

      final body = response['body'] as String;

      final receiverMsg = ChatMessage(text: body, isSender: false);

      // Push via stream
      _receiverController.add(receiverMsg);

      // Also keep state list in sync
      _messages.add(receiverMsg);
      emit(ChatLoaded(List.from(_messages)));

      _retrying = false;
    } catch (_) {
      if (!_retrying) {
        _retrying = true;
        await _fetchReceiverAndEmit(); // retry same ID once
      } else {
        _retrying = false;
        _errorController.add('Failed to receive message');
      }
    }
  }

  void _incrementId() {
    _commentId++;
    if (_commentId > 100) {
      _commentId = 1;
    }
  }

  @override
  Future<void> close() {
    _receiverController.close();
    _errorController.close();
    return super.close();
  }
}
