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
  var _eventStart = StreamedValue<DateTime>();
  var _eventEnd = StreamedValue<DateTime>();
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
    _eventTitle.value = location;
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

  void createEvent(String calendarId) async {
    //get all event info from streams
    var now = DateTime.now();

    var event = Event(
      calendarId,
      title: _eventTitle.value ?? 'No Title',
      start: now.add(Duration(hours: 1)),
      end: now.add(Duration(hours: 2)),
      description: 'testing this shit out',
    );
    // values have to be set separately bc library don't put them in the constructor
    event.location = _eventLocation.value ?? 'No location specified';

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
    _eventStart.dispose();
    _eventEnd.dispose();
    _eventAttendees.dispose();
    checkToday.cancel();
  }
}
