import 'dart:async';

import 'package:frideos_core/frideos_core.dart';
import 'package:irm_test/services.dart';

class CalendarBloc {
  final CalendarService _calendarService;

  CalendarBloc(this._calendarService) {
    //initialize events
    _checkToday = today.listen((today) {
      _calendarService.getEvents(today).then((events) {
        print('calendar bloc events initialized: $events}');
        _events.value = events;
      });
    });
  }

  StreamSubscription _checkToday;
  var _events = StreamedValue<Map<DateTime, List>>();
  var _today = StreamedValue<DateTime>();

  Stream<Map<DateTime, List>> get events => _events.outStream;
  Stream<DateTime> get today => _today.outStream;

  void getEvents(Map<DateTime, List> events) {
    _events.value = events;
  }

  void setToday(DateTime today) {
    _today.value = today;
  }

  void dispose() {
    _events.dispose();
    _today.dispose();
  }
}
