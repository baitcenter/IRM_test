import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:irm_test/services.dart';
import 'package:http/http.dart' as http;
import 'package:irm_test/z_services/calendar_service/extended_event.dart';

class CalendarServiceBackend extends CalendarService {
  final String host;
  DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();

  CalendarServiceBackend(this.host);

  @override
  //TO DO check return type
  Future<bool> createEventInPhone(Event event) async {
    try {
      Result result = await deviceCalendarPlugin.createOrUpdateEvent(event);
      event.eventId = result.data;
      return result.isSuccess;
    } catch (e) {
      print(e);
      print('error creating at webservice level');
    }
    return false;
  }

  @override
  Future<List<Event>> getEventsFromPhone(
      DateTime today, String calendarId) async {
    //TO DO pass retrieveEventParams as parameter
    RetrieveEventsParams retrieveEventsParams = RetrieveEventsParams(
        //TO DO input correct parameters
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 30)));
    Result result = await deviceCalendarPlugin.retrieveEvents(
        calendarId, retrieveEventsParams);
    return result.data;
  }

  Future<bool> updateEventInPhone(Event event) async {
    try {
      Result result = await deviceCalendarPlugin.createOrUpdateEvent(event);
      return result.isSuccess;
    } catch (e) {
      print(e);
      print('error creating at webservice level');
    }
    return false;
  }

  Future<bool> deleteEventFromPhone(String calendarId, String eventId) async {
    try {
      Result result =
          await deviceCalendarPlugin.deleteEvent(calendarId, eventId);
      return result.isSuccess;
    } catch (e) {
      print('error deleting event: $eventId');
    }
    return false;
  }

  @override
  Future<bool> createEventInDB(ExtendedEvent event) async {
    Uri uri = Uri.http(host, '/createEvent');

    print('creating event in DB');
    var response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(event.toJson()));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('event DB all OK');
      return true;
    }
    return false;
  }

  @override
  Future<List<ExtendedEvent>> getEventsFromDB(User user) async {
    Uri uri = Uri.http(host, '/getevents');

    var response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(user.toJson()));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var jsonBody = json.decode(response.body);
      print(jsonBody);
      var eventsList = List<ExtendedEvent>.from(
          jsonBody.map((event) => ExtendedEvent.fromJson(event)));
      if (eventsList.isEmpty) {
        return [];
      }
      return eventsList;
    }
    return [];
  }

  Future<bool> updateEventInDB(ExtendedEvent extendedEvent) async {
    Uri uri = Uri.http(host, '/updateevent');

    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        extendedEvent.toJson(),
      ),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }
    return false;
  }

  Future<bool> deleteEventFromDB(ExtendedEvent extendedEvent) async {
    Map<String, String> queryParameters = {
      'eventId': extendedEvent.event.eventId,
      'user': extendedEvent.owner.userName
    };
    Uri uri = Uri.http(host, '/deleteevent', queryParameters);

    var response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }
    return false;
  }
}
