import 'package:device_calendar/device_calendar.dart';
import 'package:irm_test/services.dart';

class CalendarServiceBackend extends CalendarService {
  DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
  @override
  //TO DO check return type
  Future<bool> createEvent(Event event) async {
    try {
      Result result = await deviceCalendarPlugin.createOrUpdateEvent(event);
      print('result: ${result.data}');
      event.eventId = result.data;
      //push to DB here
      return result.isSuccess;
    } catch (e) {
      print(e);
      print('error creating at webservice level');
    }
    return false;
  }

  @override
  Future<Map<DateTime, List>> getEvents(
      DateTime today, String calendarId) async {
    //TO DO pass retrieveEventParams as parameter
    // TODO: implement getEvents
    RetrieveEventsParams retrieveEventsParams = RetrieveEventsParams(
        //TO DO input correct parameters
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 1)));
    Result result = await deviceCalendarPlugin.retrieveEvents(
        calendarId, retrieveEventsParams);
    print(result.data);
    return null;
  }
}
