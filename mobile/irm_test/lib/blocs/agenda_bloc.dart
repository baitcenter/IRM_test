import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';

// This bloc manages calendar selection & authorization
class AgendaBloc {
  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  var _calendars = StreamedValue<List<Calendar>>();
  var _selectedCalendar = StreamedValue<Calendar>();

  Stream<List<Calendar>> get calendars => _calendars.outStream;
  Stream<Calendar> get selectedCalendar => _selectedCalendar.outStream;

  void selectCalendar(Calendar calendar) {
    _selectedCalendar.value = calendar;
    print('calendar selected: ${_selectedCalendar.value.name}');
    return;
  }

  void retrieveCalendars() async {
    print('retrieving calendars');
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }
      Result<List<Calendar>> calendarsResult =
          await _deviceCalendarPlugin.retrieveCalendars();
      print('calendars retrieved');
      _calendars.value = calendarsResult.data;
      print('inStream');
      print(calendarsResult.data.toString());
      print('ola');
    } catch (e) {
      print(e);
    }
    return;
  }

  void dispose() {
    _selectedCalendar.dispose();
    _calendars.dispose();
  }
}
