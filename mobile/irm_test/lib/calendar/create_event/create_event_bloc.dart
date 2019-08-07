import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';
import 'package:irm_test/z_services/calendar_service/guest.dart';

class CreateEventBloc {
  final UserService userService;
  final CalendarService calendarService;

  CreateEventBloc(
    this.userService,
    this.calendarService,
  ) {
    getAllUsersFromDB();
  }

  var _allUsers = StreamedValue<List<User>>();
  var _eventTitle = StreamedValue<String>()..inStream('');
  var _eventLocation = StreamedValue<String>()..inStream('');
  var _eventDescription = StreamedValue<String>()..inStream('');
  var _eventStartDate = StreamedValue<String>();
  var _eventStartTime = StreamedValue<String>();
  var _eventEndDate = StreamedValue<String>();
  var _eventEndTime = StreamedValue<String>();
  var _eventAttendees = StreamedValue<List<Attendee>>();
  var _attendeeNames = StreamedValue<List<String>>();
  var _selectedAttendees = StreamedValue<List<User>>()..inStream(List<User>());
  var _eventToSend = StreamedValue<Event>();

  Stream<List<User>> get allUsers => _allUsers.outStream;

  Stream<String> get eventTitle => _eventTitle.outStream;
  Stream<String> get eventLocation => _eventLocation.outStream;
  Stream<List<Attendee>> get attendees => _eventAttendees.outStream;
  Stream<List<String>> get attendeeNames => _attendeeNames.outStream;

  void getAllUsersFromDB() async {
    try {
      var users = await userService.getAllUsers();
      _allUsers.value = users;
      print('all users: ${_allUsers.value}');

      List<Attendee> _attendees = List<Attendee>.from(users.map((user) {
        return Attendee(user.userName);
      }));
      _eventAttendees.value = _attendees;
      print('Attendee list: $_attendees');

      List<String> _attendeesList =
          List<String>.from(_attendees.map((attendee) => attendee.name));
      _attendeeNames.value = _attendeesList;
      print('attendees name list: $_attendeesList');

      return;
    } catch (e) {
      print('error fetching users: $e');
      return;
    }
  }

  void addAttendee(String attendeeName) {
    for (var user in _allUsers.value) {
      if (user.userName == attendeeName) {
        print(_selectedAttendees.value.length);
        _selectedAttendees.value.add(user);
        print(_selectedAttendees.value.length);
      }
    }
  }

  //TO DO: test behavior of .InStream to make code more compact
  void updateEventTitle(String title) {
    _eventTitle.value = title;
    print('title updated');
    return;
  }

  void updateEventLocation(String location) {
    _eventLocation.value = location;
    print('location updated');
    return;
  }

  void updateEventDescription(String description) {
    _eventDescription.value = description;
    print('description updated');
    return;
  }

  void updateEventStartDate(String startDate) {
    _eventStartDate.value = startDate;
    print('start date updated: ${_eventStartDate.value}');
    return;
  }

  void updateEventStartTime(String startTime) {
    _eventStartTime.value = startTime;
    print('start time updated:${_eventStartTime.value}');
    return;
  }

  void updateEventEndDate(String endDate) {
    _eventEndDate.value = endDate;
    print('end date updated: ${_eventEndDate.value}');
    return;
  }

  void updateEventEndTime(String endTime) {
    _eventEndTime.value = endTime;
    print('endTime updated:${_eventEndTime.value}');
    return;
  }

  DateTime convertStringsToDate(String dateString, String timeString) {
    try {
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

  void createEventInDbAndLocally(String calendarId) async {
    var createdLocally = await createEvent(calendarId);
    if (createdLocally) {
      createEventInDb();
      return;
    }
    print('error creating event in calendar and DB');
  }

  void testStreams() {
    print(_eventStartDate.value);
    print(_eventEndDate.value);
    print(_eventEndTime.value);
    print(_eventStartTime.value);
    print(_eventTitle.value);
    print(_eventDescription.value);
    print(_selectedAttendees.value);
    return;
  }

  Future<bool> createEvent(String calendarId) async {
    //get all event info from streams
    print(_eventStartDate.value);
    var startDateAndTime =
        convertStringsToDate(_eventStartDate.value, _eventStartTime.value);
    var endDateAndTime =
        convertStringsToDate(_eventEndDate.value, _eventEndTime.value);

    List<Attendee> calendarAttendees = List<Attendee>.from(
        _selectedAttendees.value.map((user) => Attendee(user.userName)));

//TO DO: put location in description as workaround to library shortcoming
    var event = Event(
      calendarId,
      title: _eventTitle.value,
      start: startDateAndTime,
      end: endDateAndTime,
      description: _eventDescription.value,
    )
      ..location = _eventLocation.value
      ..attendees = calendarAttendees;

    _eventToSend.value = event;

    try {
      bool isCreated = await calendarService.createEvent(event);
      if (isCreated) {
        print('event created');
        return true;
      }
      print('event not created');
      return false;
    } catch (e) {
      print(e);
      print('error creating event');
    }
    return false;
  }

  Future<bool> createEventInDb() async {
    User owner = await userService.getUser();
    List<User> guestsUsers = _selectedAttendees.value;
    List<Guest> guests = List<Guest>.from(guestsUsers
        .map((user) => Guest(name: user.userName, user: user, isAttending: 1)));
    Event event = _eventToSend.value;
    ExtendedEvent dbEvent = ExtendedEvent(
        event: event, owner: owner, guests: guests, isCancelled: false);
    try {
      bool createdInDb = await calendarService.createEventInDB(dbEvent);
      if (createdInDb) {
        print('event created');
        return createdInDb;
      }
      print('oops');
      return createdInDb;
    } catch (e) {
      print('error creating event in DB:$e');
    }
    return false;
  }

  dispose() {
    _allUsers.dispose();
    _attendeeNames.dispose();
    _eventTitle.dispose();
    _eventLocation.dispose();
    _eventDescription.dispose();
    _eventStartDate.dispose();
    _eventEndDate.dispose();
    _eventStartTime.dispose();
    _eventEndTime.dispose();
    _eventAttendees.dispose();
    _eventToSend.dispose();
    _selectedAttendees.dispose();
  }
}
