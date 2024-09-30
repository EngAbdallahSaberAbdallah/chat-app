part of 'chat_cubit.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = ChatInitial;
  const factory ChatState.loading() = ChatLoading;
  const factory ChatState.loaded({
     required List<ChatModel> messages,  
    required bool isTyping,             
    required bool isOnline,             
  }) = ChatLoaded;
  const factory ChatState.error(String message) = ChatError;
}
