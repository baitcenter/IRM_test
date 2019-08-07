import 'package:irm_test/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'guest.g.dart';

@JsonSerializable()
class Guest {
  final String name;
  final User user;
  final int isAttending;

  Guest({this.name, this.user, this.isAttending});

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  Map<String, dynamic> toJson() => _$GuestToJson(this);
}
