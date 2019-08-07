// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extended_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtendedEvent _$ExtendedEventFromJson(Map json) {
  return ExtendedEvent(
    event: json['event'] == null
        ? null
        : Event.fromJson((json['event'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    owner: json['owner'] == null
        ? null
        : User.fromJson((json['owner'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    guests: (json['guests'] as Map)?.map(
      (k, e) => MapEntry(
          k as String,
          e == null
              ? null
              : Guest.fromJson((e as Map)?.map(
                  (k, e) => MapEntry(k as String, e),
                ))),
    ),
    isCancelled: json['isCancelled'] as bool,
  );
}

Map<String, dynamic> _$ExtendedEventToJson(ExtendedEvent instance) =>
    <String, dynamic>{
      'event': instance.event,
      'owner': instance.owner,
      'guests': instance.guests,
      'isCancelled': instance.isCancelled,
    };
