// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userName: json['userName'] as String,
    calendar: json['calendar'] == null
        ? null
        : Calendar.fromJson(json['calendar'] as Map<String, dynamic>),
    uid: json['uid'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userName': instance.userName,
      'calendar': instance.calendar,
      'uid': instance.uid,
    };
