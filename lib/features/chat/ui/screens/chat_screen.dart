import 'package:chat_app/core/constants/assets_paths.dart';
import 'package:chat_app/features/chat/logic/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Fetch messages when the screen is initialized
    context.read<ChatCubit>().fetchMessages(widget.chatId);

    // Listen for real-time typing and online status changes
    context
        .read<ChatCubit>()
        .listenUserTypingStatus(widget.chatId, widget.otherUserId);
    context.read<ChatCubit>().listenUserOnlineStatus(widget.otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(AssetsPaths.avatar),
            ),
            const SizedBox(width: 8),
            Text(widget.otherUserName),
            Spacer(),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoaded && state.isOnline) {
                  return Icon(Icons.circle,
                      color: Colors.green, size: 12); // Online
                }
                return Icon(Icons.circle,
                    color: Colors.grey, size: 12); // Offline
              },
            ),
            Icon(Icons.more_vert),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            bool isMe = message.senderId ==
                                'currentUserId'; // Replace with actual user ID
                            return Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isMe ? Colors.blue : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.message,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      message.getFormattedTimestamp(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (state.isTyping)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Sebastian is typing...",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                    ],
                  );
                } else {
                  return Center(child: Text('Error loading messages'));
                }
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: (text) {
                context.read<ChatCubit>().updateTypingStatus(
                      widget.chatId,
                      'currentUserId', // Replace with actual user ID
                      text.isNotEmpty,
                    );
              },
              decoration: InputDecoration(
                hintText: 'Message...',
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                context.read<ChatCubit>().sendMessage(
                      widget.chatId,
                      _messageController.text,
                      'currentUserId', // Replace with actual user ID
                    );
                _messageController.clear();
                context.read<ChatCubit>().updateTypingStatus(
                      widget.chatId,
                      'currentUserId', // Replace with actual user ID
                      false,
                    );
              }
            },
          ),
        ],
      ),
    );
  }
}
