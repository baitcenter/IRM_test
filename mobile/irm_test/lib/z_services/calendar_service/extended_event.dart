import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_services/calendar_service/guest.dart';
import 'package:json_annotation/json_annotation.dart';

part 'extended_event.g.dart';

@JsonSerializable()
class ExtendedEvent {
  final Event event;
  final User owner;
  final Map<String, Guest> guests;
  final bool isCancelled;

  ExtendedEvent(
      {@required this.event,
      @required this.owner,
      @required this.guests,
      @required this.isCancelled})
      : assert(event != null),
        assert(owner != null),
        assert(guests != null),
        assert(isCancelled != null);

  factory ExtendedEvent.fromJson(Map<String, dynamic> json) =>
      _$ExtendedEventFromJson(json);

  Map<String, dynamic> toJson() => _$ExtendedEventToJson(this);
}
