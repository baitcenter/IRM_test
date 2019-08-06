import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:irm_test/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'extended_event.g.dart';

@JsonSerializable()
class ExtendedEvent {
  final Event event;
  final User owner;
  final List<User> guests;

  ExtendedEvent(
      {@required this.event, @required this.owner, @required this.guests})
      : assert(event != null),
        assert(owner != null),
        assert(guests != null);

  factory ExtendedEvent.fromJson(Map<String, dynamic> json) =>
      _$ExtendedEventFromJson(json);

  Map<String, dynamic> toJson() => _$ExtendedEventToJson(this);
}
