import 'package:chat_app/core/helpers/date_time_formater.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  final String message;
  final String senderId;
  final DateTime timestamp;

  ChatModel({
    required this.message,
    required this.senderId,
    required this.timestamp
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

   String getFormattedTimestamp() {
    return CustomDateTimeFormatter.formatTime(timestamp);
  }
}
