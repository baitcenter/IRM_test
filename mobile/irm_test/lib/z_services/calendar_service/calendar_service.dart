import 'package:device_calendar/device_calendar.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';

abstract class CalendarService {
  Future<List<Event>> getEventsFromPhone(DateTime today, String calendarId);
  Future<bool> createEventInPhone(Event event);
  createEventInDB(ExtendedEvent event);
  Future<List<ExtendedEvent>> getEventsFromDB(User user);
  Future<bool> updateEventInPhone(Event event);
  Future<bool> deleteEventFromPhone(String calendarId, String eventId);
  Future<bool> deleteEventFromDB(ExtendedEvent extendedEvent);
  Future<bool> updateEventInDB(ExtendedEvent extendedEvent);
}
