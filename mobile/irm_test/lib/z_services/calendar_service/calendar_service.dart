import 'package:device_calendar/device_calendar.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';

abstract class CalendarService {
  Future<List<Event>> getEvents(DateTime today, String calendarId);
  Future<bool> createEvent(Event event);
  createEventInDB(ExtendedEvent event);
  getEventsFromDB();
}
