import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:irm_test/z_blocs/agenda_bloc.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_services/calendar_service/calendar_service.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';
import 'package:irm_test/z_services/user_service/user.dart';

class EventDetailsBloc {
  final AppBloc appBloc;
  final CalendarService calendarService;
  final AgendaBloc agendaBloc;

  EventDetailsBloc(this.appBloc, this.calendarService, this.agendaBloc) {
    userListener = appBloc.user.listen((user) {
      _user.value = user;
    });
    calendarListener = appBloc.selectedCalendar.listen((calendar) {
      _calendarId.value = calendar.id;
    });
    phoneEventsListener = agendaBloc.phoneEvents.listen((phoneEvents) {
      _phoneEvents.value = phoneEvents;
    });
  }

  StreamSubscription userListener;
  StreamSubscription calendarListener;
  StreamSubscription phoneEventsListener;
  var _user = StreamedValue<User>();
  var _calendarId = StreamedValue<String>();
  var _phoneEvents = StreamedValue<List<Event>>();

  Stream get user => _user.outStream;

  Future<bool> deleteEvent(ExtendedEvent extendedEvent) async {
    var phoneEvents = _phoneEvents.value;
    String eventId;
    Event eventFromPhone;
    for (var phoneEvent in phoneEvents) {
      var event = extendedEvent.event;
      if (phoneEvent.title == event.title &&
          phoneEvent.start == event.start &&
          phoneEvent.end == event.end) {
        eventId = phoneEvent.eventId;
        eventFromPhone = phoneEvent;
      }
    }
    try {
      var deletedOnPhone = await calendarService.deleteEventFromPhone(
          _calendarId.value, eventId);
      print(deletedOnPhone);
    } catch (e) {
      print('error deleting event from phone: $e');
    }
    try {
      var deletedOnDb = await calendarService.deleteEventFromDB(extendedEvent);
      print(deletedOnDb);
    } catch (err) {
      print('error deleting from DB: $err');
      return false;
    }
    agendaBloc.removeEventFromStreams(eventFromPhone, extendedEvent);
    return true;
  }

  dispose() {
    _calendarId.dispose();
    _phoneEvents.dispose();
    _user.dispose();
    userListener.cancel();
    calendarListener.cancel();
    phoneEventsListener.cancel();
  }
}
