// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Guest _$GuestFromJson(Map json) {
  return Guest(
    user: json['user'] == null
        ? null
        : User.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    isAttending: json['isAttending'] as int,
  );
}

Map<String, dynamic> _$GuestToJson(Guest instance) => <String, dynamic>{
      'user': instance.user,
      'isAttending': instance.isAttending,
    };
