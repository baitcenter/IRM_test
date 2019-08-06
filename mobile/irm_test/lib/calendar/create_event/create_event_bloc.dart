import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';

class CreateEventBloc {
  final UserService userService;
  final CalendarService _calendarService;

  CreateEventBloc(
    this.userService,
    this._calendarService,
  );

  var _allUsers = StreamedValue<List<User>>();
  var _buttonPressed = StreamedValue<bool>()..value = false;

  var _eventTitle = StreamedValue<String>()..inStream('');
  var _eventLocation = StreamedValue<String>()..inStream('');
  var _eventDescription = StreamedValue<String>()..inStream('');
  var _eventStartDate = StreamedValue<String>();
  var _eventStartTime = StreamedValue<String>();
  var _eventEndDate = StreamedValue<String>();
  var _eventEndTime = StreamedValue<String>();
  var _eventAttendees = StreamedValue<List<Attendee>>();
  var _attendeeNames = StreamedValue<List<String>>();

  Stream<List<User>> get allUsers => _allUsers.outStream;
  Stream<bool> get isButtonPressed => _buttonPressed.outStream;

  Stream<String> get eventTitle => _eventTitle.outStream;
  Stream<String> get eventLocation => _eventLocation.outStream;
  Stream<List<Attendee>> get attendees => _eventAttendees.outStream;
  Stream<List<String>> get attendeeNames => _attendeeNames.outStream;

  void pressButtonState() {
    _buttonPressed.value = !_buttonPressed.value;
    return;
  }

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

  //TO DO: test behavior of .InStream to make code more compact
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

  dispose() {
    _buttonPressed.dispose();
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
  }
}
