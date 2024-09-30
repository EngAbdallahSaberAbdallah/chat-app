import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart'; // This will be generated

@JsonSerializable()
class UserModel {
  final String userId;
  final String name;
  final String email;
  final String avatarUrl;

  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.avatarUrl,
  });

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
