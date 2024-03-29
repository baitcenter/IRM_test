import 'package:device_calendar/device_calendar.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';

class CalendarServiceFake extends CalendarService {
  DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
  @override
  Future<List<Event>> getEventsFromPhone(
      DateTime today, String calendarId) async {
    // TODO: implement getEvents
    final _selectedDay = today;

    var events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): [
        'Event A4',
        'Event B4',
        'Event C4'
      ],
      _selectedDay.subtract(Duration(days: 4)): [
        'Event A5',
        'Event B5',
        'Event C5'
      ],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      _selectedDay.add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };
    await Future.delayed(Duration(milliseconds: 500));
    return null;
  }

  @override
  Future<bool> createEventInPhone(Event event) async {
    // TODO: implement createEvent
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
  createEventInDB(ExtendedEvent event) {
    // TODO: implement createEventInDB
    return null;
  }

  @override
  Future<List<ExtendedEvent>> getEventsFromDB(User user) {
    // TODO: implement getEventsFromDB
    return null;
  }

  @override
  Future<bool> updateEventInPhone(Event event) {
    // TODO: implement updateEventInPhone
    return null;
  }

  @override
  Future<bool> deleteEventFromPhone(String calendarId, String eventId) {
    // TODO: implement deleteEventFromPhone
    return null;
  }

  @override
  Future<bool> deleteEventFromDB(ExtendedEvent extendedEvent) {
    // TODO: implement deleteEventFromDB
    return null;
  }

  @override
  Future<bool> updateEventInDB(ExtendedEvent extendedEvent) {
    // TODO: implement updateEventInDB
    return null;
  }
}
