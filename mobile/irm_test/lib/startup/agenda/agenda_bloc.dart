import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:intl/intl.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';

class AgendaBloc {
  final CalendarService _calendarService;
  final AppBloc _appBloc;

  AgendaBloc(this._calendarService, this._appBloc) {
    user = _appBloc.user.listen((user) {
      _user.value = user;
    });

    //fetch events from phone and DB and pass data into streams
    checkToday = today.listen((today) {
      selectedCalendar = _appBloc.selectedCalendar.listen((calendar) {
        fetchAndPrepareEventsForDisplay(today, calendar.id);
      });
    });
  }
  StreamSubscription selectedCalendar;
  StreamSubscription checkToday;
  StreamSubscription user;

  var _eventsToDisplay = StreamedValue<Map<DateTime, List>>();
  var _today = StreamedValue<DateTime>();
  var _eventsFromDB = StreamedValue<List<ExtendedEvent>>();
  var _eventsFromPhone = StreamedValue<List<Event>>();
  var _user = StreamedValue<User>();

  Stream<Map<DateTime, List>> get events => _eventsToDisplay.outStream;
  Stream<DateTime> get today => _today.outStream;

  void setToday(DateTime today) {
    _today.value = today;
    return;
  }

  Map<DateTime, List> convertListToMap(List<Event> eventList) {
    var today = _today.value;
    Map<DateTime, List> eventMap = {today: []};
    for (var event in eventList) {
      if (compareDates(today, event.start)) {
        eventMap[today].add(event);
      }
    }

    return eventMap;
  }

  Future<List<ExtendedEvent>> getEventsFromDB(User user) async {
    List<ExtendedEvent> eventsFromDB;
    try {
      eventsFromDB = await _calendarService.getEventsFromDB(user);
    } catch (e) {
      print('problem with events API call: $e');
    }
    return eventsFromDB;
  }

  void fetchAndPrepareEventsForDisplay(
      DateTime today, String calendarId) async {
    try {
      var eventsFromPhone =
          await _calendarService.getEventsFromPhone(today, calendarId);
      _eventsFromPhone.value = eventsFromPhone;
      print('phone events: ${_eventsFromPhone.value}');
      var eventsFromDB = await getEventsFromDB(_user.value);
      _eventsFromDB.value = eventsFromDB;
      print('db events: ${_eventsFromDB.value}');

      var eventsMap = syncEventsFromPhoneAndDb(
          _eventsFromDB.value, _eventsFromPhone.value, _user.value);
      _eventsToDisplay.value = eventsMap;
    } catch (e) {
      print('error managing event :$e');
    }
  }

  //avoid null
  Map<DateTime, List> syncEventsFromPhoneAndDb(
      List<ExtendedEvent> fromDb, List<Event> phone, User user) {
    List<Event> eventsList = [];
    Map<DateTime, List> eventsMap = {};
    print('sync user:${user.userName}');

    if (fromDb.isNotEmpty) {
      eventsList = filterDbEvents(eventsList, fromDb, user);
      print('first step eventList: $eventsList');
    }

    if (fromDb.isNotEmpty && phone.isNotEmpty) {
      for (var extendedEvent in fromDb) {
        for (var event in phone) {
          if (event != extendedEvent.event) {
            eventsList.add(event);
          }
        }
        print('second step eventLits: $eventsList');
      }
    }

    if (fromDb.isEmpty && phone.isNotEmpty) {
      eventsMap = convertListToMap(phone);
      return eventsMap;
    }

    print('list before mapping: $eventsList');
    eventsMap = convertListToMap(eventsList);
    return eventsMap;
  }

  bool compareDates(DateTime today, DateTime event) {
    var todayDate = DateFormat('yyyy-MM-dd').format(today);
    print(todayDate);
    var eventDate = DateFormat('yyyy-MM-dd').format(event);
    print(eventDate);

    return todayDate == eventDate;
  }

  List<Event> filterDbEvents(
      List<Event> eventsList, List<ExtendedEvent> fromDb, User user) {
    print('filterdbevents user:${user.userName}');
    for (var extendedEvent in fromDb) {
      if (extendedEvent.owner == user && !extendedEvent.isCancelled) {
        eventsList.add(extendedEvent.event);
      }

      ///Add condition to avoid null
      if (extendedEvent.guests[user.userName].user.uid == user.uid &&
          !extendedEvent.isCancelled &&
          extendedEvent.guests[user.userName].isAttending != 2) {
        print('found one!');
        eventsList.add(extendedEvent.event);
      }
    }
    print('filter eventlist: $eventsList');
    return eventsList;
  }

  dispose() {
    _eventsToDisplay.dispose();
    _eventsFromDB.dispose();
    _eventsFromPhone.dispose();
    _today.dispose();
    _user.dispose();
    checkToday.cancel();
    selectedCalendar.cancel();
    user.cancel();
  }
}
