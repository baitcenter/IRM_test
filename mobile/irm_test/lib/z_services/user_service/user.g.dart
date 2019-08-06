// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
    userName: json['userName'] as String,
    calendar: json['calendar'] == null
        ? null
        : Calendar.fromJson((json['calendar'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    uid: json['uid'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userName': instance.userName,
      'calendar': instance.calendar,
      'uid': instance.uid,
    };
