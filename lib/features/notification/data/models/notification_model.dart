import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String notificationId;
  final String userId;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.message,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
