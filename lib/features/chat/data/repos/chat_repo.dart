import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String chatsCollection = 'chats'; // Collection for chats
const String messagesSubCollection =
    'messages'; // Subcollection for chat messages
const String usersCollection = 'users'; // Collection for users

class ChatRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate a unique chat ID based on user IDs
  String getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }

  /// Send a message to a specific chat
  Future<ChatModel> sendMessage(
      String chatId, String message, String senderId) async {
    final timestamp = DateTime.now();

    // Create a new chat message model
    final newMessage = ChatModel(
      message: message,
      senderId: senderId,
      timestamp: timestamp,
    );

    // Add the message to Firestore in the 'chats' collection -> 'messages' subcollection
    await _firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesSubCollection)
        .add(newMessage.toJson());

    // Return the newly created message object
    return newMessage;
  }

  /// Get real-time chat message stream for a particular chat
  Stream<List<ChatModel>> getChatStream(String chatId) {
    return _firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesSubCollection)
        .orderBy('timestamp') // Order messages by timestamp
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
                (doc) => ChatModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Update typing status for a user
  Future<void> updateTypingStatus(
      String chatId, String userId, bool isTyping) async {
    await _firestore.collection(chatsCollection).doc(chatId).update({
      'typingStatus.$userId': isTyping,
    });
  }

  /// Listen to typing status of another user
  Stream<bool> listenTypingStatus(String chatId, String otherUserId) {
    return _firestore
        .collection(chatsCollection)
        .doc(chatId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data != null && data['typingStatus'] != null) {
        return data['typingStatus'][otherUserId] ?? false;
      }
      return false;
    });
  }

  /// Update user's online status
  Future<void> updateOnlineStatus(String userId, bool isOnline) async {
    await _firestore.collection(usersCollection).doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': isOnline
          ? FieldValue.serverTimestamp()
          : FieldValue.serverTimestamp(),
    });
  }

  /// Listen to online status of a user
  Stream<bool> listenUserOnlineStatus(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      return data != null && data['isOnline'] ?? false;
    });
  }

  /// Fetch user details
  Future<DocumentSnapshot> fetchUserDetails(String userId) async {
    return await _firestore.collection(usersCollection).doc(userId).get();
  }
}
