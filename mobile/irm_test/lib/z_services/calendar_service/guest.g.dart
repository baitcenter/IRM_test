// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Guest _$GuestFromJson(Map json) {
  return Guest(
    name: json['name'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    isAttending: json['isAttending'] as int,
  );
}

Map<String, dynamic> _$GuestToJson(Guest instance) => <String, dynamic>{
      'name': instance.name,
      'user': instance.user,
      'isAttending': instance.isAttending,
    };
