import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/chat/data/repos/chat_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';


class ChatCubit extends Cubit<ChatState> {
  final ChatRepo _chatRepository;
  ChatCubit(this._chatRepository) : super(ChatState.initial());

  /// Set the chat ID in the state
  String generateChatId(String userId1, String userId2) {
    return _chatRepository.getChatId(userId1, userId2);
    
  }


Future<void> fetchMessages(String chatId) async {
    emit(ChatState.loading());
    _chatRepository.getChatStream(chatId).listen((messages) {
      emit(ChatState.loaded(
        messages: messages,
        isTyping: false, // Set initial typing status to false
        isOnline: true,  // Set initial online status, update later
      ));
    });
  }

  Future<void> sendMessage(String chatId, String message, String senderId) async {
    await _chatRepository.sendMessage(chatId, message, senderId);
  }

  void updateTypingStatus(String chatId, String userId, bool isTyping) {
    _chatRepository.updateTypingStatus(chatId, userId, isTyping);
  }

void listenUserTypingStatus(String chatId, String otherUserId) {
  _chatRepository.listenTypingStatus(chatId, otherUserId).listen((isTyping) {
    // Use pattern matching to extract the loaded state
    if (state is ChatLoaded) {
      final loadedState = state as ChatLoaded; // Cast to _Loaded to access messages
      emit(ChatState.loaded(
        messages: loadedState.messages, // Access messages from the loaded state
        isTyping: isTyping,              // Update typing status
        isOnline: loadedState.isOnline,  // Keep the same online status
      ));
    }
  });
}

 void listenUserOnlineStatus(String userId) {
    _chatRepository.listenUserOnlineStatus(userId).listen((isOnline) {
      if (state is ChatLoaded) {
        final loadedState = state as ChatLoaded;
        emit(ChatState.loaded(
          messages: loadedState.messages,
          isTyping: loadedState.isTyping,
          isOnline: isOnline,
        ));
      }
    });
  }
}
