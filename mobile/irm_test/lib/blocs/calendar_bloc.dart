import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:irm_test/services.dart';

//this bloc manages events
class CalendarBloc {
  final CalendarService _calendarService;

  CalendarBloc(this._calendarService) {
    //initialize events
    checkToday = today.listen((today) {
      _calendarService.getEvents(today).then((events) {
        print('calendar bloc events initialized: $events}');
        _events.value = events;
      });
    });
  }

  StreamSubscription checkToday;
  var _events = StreamedValue<Map<DateTime, List>>();
  var _today = StreamedValue<DateTime>();
  var _eventTitle = StreamedValue<String>()..inStream('');
  var _eventLocation = StreamedValue<String>()..inStream('');
  var _eventDescription = StreamedValue<String>()..inStream('');
  var _eventStartDate = StreamedValue<String>();
  var _eventStartTime = StreamedValue<String>();
  var _eventEndDate = StreamedValue<String>();
  var _eventEndTime = StreamedValue<String>();
  var _eventAttendees = StreamedValue<Attendee>();

  Stream<Map<DateTime, List>> get events => _events.outStream;
  Stream<DateTime> get today => _today.outStream;
  Stream<String> get eventTitle => _eventTitle.outStream;
  Stream<String> get eventLocation => _eventLocation.outStream;

  void updateEventTitle(String title) {
    _eventTitle.value = title;
    return;
  }

  void updateEventLocation(String location) {
    _eventLocation.value = location;
    return;
  }

  void updateEventDescription(String description) {
    _eventDescription.value = description;
    return;
  }

  void updateEventStartDate(String startDate) {
    _eventStartDate.value = startDate;
    print('start date updated: ${_eventStartDate.value}');
    return;
  }

  void updateEventStartTime(String startTime) {
    _eventStartTime.value = startTime;
    return;
  }

  void updateEventEndDate(String endDate) {
    _eventEndDate.value = endDate;
    return;
  }

  void updateEventEndTime(String endTime) {
    _eventEndTime.value = endTime;
    return;
  }

  void getEvents(Map<DateTime, List> events) {
    _events.value = events;
    return;
  }

  void setToday(DateTime today) {
    _today.value = today;
    return;
  }

  DateTime convertStringsToDate(String dateString, String timeString) {
    try {
      print('date fallback : ${DateTime.parse('0000-00-00 00:00:00')}');
      print('dateString: $dateString');
      print('timeString: $timeString');
      DateTime convertedDate = DateTime.parse('${dateString[6]}'
          '${dateString[7]}'
          '${dateString[8]}'
          '${dateString[9]}-'
          '${dateString[3]}'
          '${dateString[4]}-'
          '${dateString[0]}'
          '${dateString[1]} '
          '${timeString[0]}'
          '${timeString[1]}'
          '${timeString[2]}'
          '${timeString[3]}'
          '${timeString[4]}'
          ':00');
      return convertedDate;
    } catch (e) {
      print('date conversion error:$e');
      return DateTime.parse('0000-00-00 00:00:00');
    }
  }

  void createEvent(String calendarId) async {
    //get all event info from streams
    var startDateAndTime =
        convertStringsToDate(_eventStartDate.value, _eventStartTime.value);
    var endDateAndTime =
        convertStringsToDate(_eventEndDate.value, _eventEndTime.value);

//TO DO: put location in description as workaround to library shortcoming
    var event = Event(
      calendarId,
      title: _eventTitle.value,
      start: startDateAndTime,
      end: endDateAndTime,
      description: _eventDescription.value,
    )..location = _eventLocation.value;

    try {
      bool isCreated = await _calendarService.createEvent(event);
      if (isCreated) {
        print('event created');
        return;
      }
      print('event not created');
      return;
    } catch (e) {
      print(e);
      print('error creating event');
    }
    return;
  }

  void dispose() {
    _events.dispose();
    _today.dispose();
    _eventTitle.dispose();
    _eventLocation.dispose();
    _eventDescription.dispose();
    _eventStartDate.dispose();
    _eventEndDate.dispose();
    _eventStartTime.dispose();
    _eventEndTime.dispose();
    _eventAttendees.dispose();
    checkToday.cancel();
  }
}
