import 'package:device_calendar/device_calendar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String userName;
  final Calendar calendar;
  final String uid;

  User({this.userName, this.calendar, this.uid});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
