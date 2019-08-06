import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:intl/intl.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';

class AgendaBloc {
  final CalendarService _calendarService;
  final AppBloc _appBloc;

  AgendaBloc(this._calendarService, this._appBloc) {
    //initialize events
    checkToday = today.listen((today) {
      selectedCalendar = _appBloc.selectedCalendar.listen((calendar) {
        _calendarService.getEvents(today, calendar.id).then((events) {
          var eventsMap = convertListToMap(events);
          _events.value = eventsMap;
        });
      });
    });
  }
  StreamSubscription selectedCalendar;
  StreamSubscription checkToday;
  var _events = StreamedValue<Map<DateTime, List>>();
  var _today = StreamedValue<DateTime>();

  Stream<Map<DateTime, List>> get events => _events.outStream;
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

  bool compareDates(DateTime today, DateTime eventDate) {
    return DateFormat('YYYYMMDD').format(today) ==
        DateFormat('YYYYMMDD').format(eventDate);
  }

  dispose() {
    _events.dispose();
    _today.dispose();
    checkToday.cancel();
    selectedCalendar.cancel();
  }
}
