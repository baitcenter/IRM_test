import 'package:device_calendar/device_calendar.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';
import 'package:irm_test/z_services/calendar_service/guest.dart';
import 'package:irm_test/z_services/user_service/user.dart';

class MyUtils {
  static bool isUserGuest(List<Guest> guests, User user) {
    for (var guest in guests) {
      if (guest.user.uid == user.uid) {
        return true;
      }
    }
    return false;
  }

  static bool isUserOwner(ExtendedEvent extendedEvent, User user) {
    return extendedEvent.owner.uid == user.uid;
  }

  static Event getEventFromExtendedEvent(
      ExtendedEvent extendedEvent, List<Event> events) {
    var title = extendedEvent.event.title;
    var start = extendedEvent.event.start;
    var end = extendedEvent.event.end;
    var description = extendedEvent.event.description;
    for (var event in events) {
      if (event.description == description &&
          event.title == title &&
          event.start == start &&
          event.end == end) return event;
    }
    return null;
  }
}
