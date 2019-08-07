import 'dart:async';
import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:intl/intl.dart';
import 'package:irm_test/services.dart';
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
    checkToday = today.listen((today) {
      selectedCalendar = _appBloc.selectedCalendar.listen((calendar) {
        _selectedCalendar.value = calendar;
        prepareEventsForDisplayAndUpdatePhone(today, calendar.id);
      });
    });
  }
  StreamSubscription selectedCalendar;
  StreamSubscription checkToday;
  StreamSubscription userListener;

  var _eventsToDisplay = StreamedValue<Map<DateTime, List>>();
  var _today = StreamedValue<DateTime>();
  var _eventsFromDB = StreamedValue<List<ExtendedEvent>>();
  var _eventsFromPhone = StreamedValue<List<Event>>();
  var _user = StreamedValue<User>();
  var _selectedCalendar = StreamedValue<Calendar>();

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
      print('eventsFromDB API call: $eventsFromDB');
    } catch (e) {
      print('problem with events API call: $e');
    }
    return eventsFromDB;
  }

  void prepareEventsForDisplayAndUpdatePhone(
      DateTime today, String calendarId) async {
    fetchEventsFromPhoneAndDb(today, calendarId).then((_) {
      var eventsMap = syncEventsFromPhoneAndDb(
          _eventsFromDB.value, _eventsFromPhone.value, _user.value);
      _eventsToDisplay.value = eventsMap;
      updatePhoneCalendar(_eventsFromDB.value, _eventsFromPhone.value);
    });
  }

  Future<bool> fetchEventsFromPhoneAndDb(
      DateTime today, String calendarId) async {
    try {
      var eventsFromPhone =
          await _calendarService.getEventsFromPhone(today, calendarId);
      _eventsFromPhone.value = eventsFromPhone;
      print('phone events: ${_eventsFromPhone.value}');
      var eventsFromDB = await getEventsFromDB(_user.value);
      _eventsFromDB.value = eventsFromDB;
      print('db events: ${_eventsFromDB.value}');
    } catch (e) {
      print('error fetching events :$e');
    }
    return true;
  }

  Map<DateTime, List> syncEventsFromPhoneAndDb(
      List<ExtendedEvent> fromDb, List<Event> phone, User user) {
    List<Event> eventsList = [];
    eventsList = filterDbEvents(eventsList, fromDb, user);
    Map<DateTime, List> eventsMap = {};

    //Below code was to show events from phone outside of agenda. Code needs to be restructured to avoid error
/*    if (eventsList.isNotEmpty && phone.isNotEmpty) {
      for (var e in eventsList) {
        for (var p in phone) {
          if (e.title != p.title) {
            eventsList.add(p);
          }
        }
      }
    }*/
    if (fromDb.isEmpty && phone.isNotEmpty) {
      eventsMap = convertListToMap(phone);
      return eventsMap;
    }

    eventsMap = convertListToMap(eventsList);
    return eventsMap;
  }

  void updatePhoneCalendar(
      List<ExtendedEvent> fromDB, List<Event> fromPhone) async {
    for (var dbEvent in fromDB) {
      if (dbEvent.owner.uid == _user.value.uid) {
        var updated = await _calendarService.createEvent(dbEvent.event);
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
        for (var phoneEvent in fromPhone) {
          //Add more conditions to avoid wrong results.
          if (phoneEvent.title == invitation.title &&
              phoneEvent.start == invitation.start) {
            var createInvitation =
                await _calendarService.createEvent(invitation);
            print(
                'existing event recreated on phone:${invitation.title} : $createInvitation');
            if (createInvitation) {
              var deleted = await _calendarService.deleteEventFromPhone(
                  _selectedCalendar.value.id, phoneEvent.eventId);
              print('event deleted: ${phoneEvent.title}: $deleted');
            }
          } else {
            var createInvitation =
                await _calendarService.createEvent(invitation);
            print(
                ' new event created on phone:${invitation.title} : $createInvitation');
          }
        }
      }
    }
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
    for (var extendedEvent in fromDb) {
      if (extendedEvent.owner.userName == user.userName &&
          !extendedEvent.isCancelled) {
        eventsList.add(extendedEvent.event);
      }
      List<Guest> isGuest = extendedEvent.guests
          .where((guest) => guest.name == user.userName)
          .toList();
      print(isGuest.isNotEmpty);

      if (isGuest.isNotEmpty &&
          !extendedEvent.isCancelled &&
          isGuest[0].isAttending != 2) {
        eventsList.add(extendedEvent.event);
      }
    }
    //replace calendarId by user's to allow writing on phone
    for (var e in eventsList) {
      e.calendarId = _selectedCalendar.value.id;
    }
    return eventsList;
  }

  dispose() {
    _eventsToDisplay.dispose();
    _eventsFromDB.dispose();
    _eventsFromPhone.dispose();
    _selectedCalendar.dispose();
    _today.dispose();
    _user.dispose();
    checkToday.cancel();
    selectedCalendar.cancel();
    userListener.cancel();
  }
}
