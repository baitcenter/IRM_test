abstract class CalendarService {
  Future<Map<DateTime, List>> getEvents(DateTime today);
}
