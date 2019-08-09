import 'dart:async';
import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:intl/intl.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/utils/utils.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';
import 'package:irm_test/z_services/calendar_service/guest.dart';

class AgendaBloc {
  final CalendarService _calendarService;
  final AppBloc _appBloc;

  AgendaBloc(this._calendarService, this._appBloc) {
    userListener = _appBloc.user.listen((user) {
      _user.value = user;
    });

    //fetch events from phone and DB and pass data into streams
    checkToday = today.listen((today) async {
      selectedCalendar = _appBloc.selectedCalendar.listen((calendar) async {
        _selectedCalendar.value = calendar;
        await prepareEventsForDisplayAndUpdatePhone(today, calendar.id);
        Timer.periodic(Duration(seconds: 300), (timer) async {
          await prepareEventsForDisplayAndUpdatePhone(today, calendar.id);
        });
      });
    });

    notifyUpdate = updateStream.listen((ping) async {
      await prepareEventsForDisplayAndUpdatePhone(
          _today.value, _selectedCalendar.value.id);
    });
  }
  StreamSubscription selectedCalendar;
  StreamSubscription checkToday;
  StreamSubscription userListener;
  StreamSubscription notifyUpdate;
  Timer timer;

  var _eventsToDisplay = StreamedValue<Map<DateTime, List>>();
  var _today = StreamedValue<DateTime>();
  var _eventsFromDB = StreamedValue<List<ExtendedEvent>>();
  var _eventsFromPhone = StreamedValue<List<Event>>();
  var _user = StreamedValue<User>();
  var _selectedCalendar = StreamedValue<Calendar>();
  var _selectedEvent = StreamedValue<Event>();
  var _selectedExtendedEvent = StreamedValue<ExtendedEvent>();
  var _notifyEventsUpdated = StreamedValue<bool>();

  Stream<Map<DateTime, List>> get events => _eventsToDisplay.outStream;
  Stream<DateTime> get today => _today.outStream;

  Stream get selectedEvent => _selectedEvent.outStream;
  Stream get selectedExtendedEvent => _selectedExtendedEvent.outStream;

  Stream get phoneEvents => _eventsFromPhone.outStream;

  Stream get updateStream => _notifyEventsUpdated.outStream;

  void upDateStreamForDisplay() {
    prepareEventsForDisplayAndUpdatePhone(
        _today.value, _selectedCalendar.value.id);
  }

  void notifyEventUpdate(bool ping) {
    _notifyEventsUpdated.value = ping;
    return;
  }

  void setToday(DateTime today) {
    _today.value = today;
    return;
  }

  void selectEvent(Event event) {
    _selectedEvent.value = event;
    return;
  }

  void removeEventFromStreams(Event event, ExtendedEvent extendedEvent) {
    _eventsFromDB.value.remove(extendedEvent);
    _eventsFromPhone.value.remove(event);
  }

  ExtendedEvent retrieveExtendedEvent(Event event) {
    var eventsFromDb = _eventsFromDB.value;
    for (var dbEvent in eventsFromDb) {
      var user = _user.value;
      var isGuest = MyUtils.isUserGuest(dbEvent.guests, user);
      var title = dbEvent.event.title;
      var start = dbEvent.event.start;
      var matchTitle = title == event.title;
      var matchStart = start == event.start;
      var matchOwner = MyUtils.isUserOwner(dbEvent, user);

      if ((matchTitle && matchStart) && (matchOwner || isGuest)) {
        return dbEvent;
      }
    }
    return null;
  }

  Map<DateTime, List> convertListToMap(List<Event> eventList) {
    var today = _today.value;
    Map<DateTime, List> eventMap = {today: []};
    for (var event in eventList) {
      print('converting event to map: ${event.title}');
      print('date follows');
      if (compareDates(today, event.start)) {
        eventMap[today].add(event);
      }
    }
    //FIX: without this calendar only display events from DB for the current day
    for (var event in eventList) {
      var date = DateFormat('yyyy-MM-dd').format(event.start);
      var day = DateTime.parse(date + ' 00:00:00.000');
      var dateOfToday = DateFormat('yyyy-MM-dd').format(today);
      if (date != dateOfToday) {
        if (eventMap[day] == null) {
          eventMap[day] = [];
        }
        eventMap[day].add(event);
        print('added to map ${event.title}');
      }
    }
    return eventMap;
  }

  Future<void> prepareEventsForDisplayAndUpdatePhone(
      DateTime today, String calendarId) async {
    await fetchEventsFromPhoneAndDb(today, calendarId);
    List<Event> eventsList = filterDbEvents(_eventsFromDB.value, _user.value);

    Map<DateTime, List> eventsMap = convertListToMap(eventsList);

    _eventsToDisplay.value = eventsMap;
    await updatePhoneCalendar(_eventsFromDB.value, _eventsFromPhone.value);
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

  Future<bool> fetchEventsFromPhoneAndDb(
      DateTime today, String calendarId) async {
    try {
      var eventsFromPhone =
          await _calendarService.getEventsFromPhone(today, calendarId);
      _eventsFromPhone.value = eventsFromPhone;
      var eventsFromDB = await getEventsFromDB(_user.value);
      _eventsFromDB.value = eventsFromDB;
    } catch (e) {
      print('error fetching events :$e');
    }
    return true;
  }

  List<Event> filterDbEvents(List<ExtendedEvent> fromDb, User user) {
    List<Event> eventsList = List<Event>.from(fromDb.map((extendedEvent) {
      return extendedEvent.event;
    }));
    //replace calendarId by user's to allow writing on phone
    for (var e in eventsList) {
      e.calendarId = _selectedCalendar.value.id;
    }
    return eventsList;
  }

  Future<void> updatePhoneCalendar(
      List<ExtendedEvent> fromDB, List<Event> fromPhone) async {
    for (var dbEvent in fromDB) {
      if (dbEvent.owner.uid == _user.value.uid) {
        var updated = await _calendarService.createEventInPhone(dbEvent.event);
        print('event${dbEvent.event} updated: $updated');
      }

      Event invitation;
      for (var guest in dbEvent.guests) {
        if (guest.name == _user.value.userName) {
          invitation = dbEvent.event;
        }
      }
      //if guest event exists on phone, delete and replace with version from DB
      //else just create it
      if (invitation != null) {
        invitation.eventId = null;
        for (var phoneEvent in fromPhone) {
          //Add more conditions to avoid wrong results.
          if (phoneEvent.title == invitation.title &&
              phoneEvent.start == invitation.start) {
            await _calendarService.deleteEventFromPhone(
                _selectedCalendar.value.id, phoneEvent.eventId);
            var createInvitation =
                await _calendarService.createEventInPhone(invitation);
            print(
                'existing event recreated on phone:${invitation.title} : $createInvitation');
          } else {
            var createInvitation =
                await _calendarService.createEventInPhone(invitation);
            print(
                ' new event created on phone:${invitation.title} : $createInvitation');
          }
        }
      }
    }
    return;
  }

  bool compareDates(DateTime today, DateTime event) {
    var todayDate = DateFormat('yyyy-MM-dd').format(today);
    var eventDate = DateFormat('yyyy-MM-dd').format(event);
    print(eventDate);

    return todayDate == eventDate;
  }

  dispose() {
    _eventsToDisplay.dispose();
    _eventsFromDB.dispose();
    _eventsFromPhone.dispose();
    _selectedCalendar.dispose();
    _selectedEvent.dispose();
    _selectedExtendedEvent.dispose();
    _today.dispose();
    _user.dispose();
    checkToday.cancel();
    notifyUpdate.cancel();
    selectedCalendar.cancel();
    userListener.cancel();
    timer.cancel();
  }
}
