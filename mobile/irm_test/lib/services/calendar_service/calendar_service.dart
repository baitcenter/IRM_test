import 'package:device_calendar/device_calendar.dart';

abstract class CalendarService {
  Future<Map<DateTime, List>> getEvents(DateTime today);
  Future<bool> createEvent(Event event);
}
