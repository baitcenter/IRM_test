import 'package:device_calendar/device_calendar.dart';

abstract class CalendarService {
  Future<List<Event>> getEvents(DateTime today, String calendarId);
  Future<bool> createEvent(Event event);
}
