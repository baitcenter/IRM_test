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
}
