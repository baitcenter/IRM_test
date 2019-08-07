import 'dart:async';
import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:irm_test/services.dart';

class AppBloc {
  final AuthService authService;
  final UserService userService;

  AppBloc(this.authService, this.userService) {
    authService.getCurrentUser().then((userFB) {
      if (userFB.uid != null) {
        checkExistingUserAndCalendar();
      }
    });

    calendarStream = selectedCalendar.listen((calendar) {
      if (calendar != null) {
        defineStep(StartUp.agenda);
        print(calendar.id);
      }
    });
  }

  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  StreamSubscription calendarStream;

  var _currentStep = StreamedValue<StartUp>()..inStream(StartUp.login);
  //phone auth
  var _phoneNr = StreamedValue<String>()..inStream('');
  var _verificationId = StreamedValue<String>();
  var _sms = StreamedValue<String>()..inStream('');
  //user details for DB
  var _userName = StreamedValue<String>();
  var _calendars = StreamedValue<List<Calendar>>();
  var _selectedCalendar = StreamedValue<Calendar>();
  var _deviceAccessGranted = StreamedValue<bool>()..inStream(false);

  Stream<StartUp> get currentStep => _currentStep.outStream;
  //phone auth
  Stream<String> get phoneNr => _phoneNr.outStream;
  Stream<String> get sms => _sms.outStream;
  //user details for DB
  Stream<String> get userName => _userName.outStream;
  Stream<List<Calendar>> get calendars => _calendars.outStream;
  Stream<Calendar> get selectedCalendar => _selectedCalendar.outStream;

  void defineStep(StartUp step) {
    _currentStep.value = step;
    return;
  }

  Future<bool> requestAccessToCalendar() async {
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data) {
      permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
        defineStep(StartUp.login);
        _deviceAccessGranted.value = false;
        return false;
      }
    }
    print('access granted');
    _deviceAccessGranted.value = true;
    return true;
  }

  //Authentication
  void inputSMS(String userInput) {
    _sms.inStream(userInput);
  }

  void inputPhoneNr(String userInput) {
    _phoneNr.inStream(userInput);
    return;
  }

  ///TO DO prevent multiple clicking on button (add bool "is_loading")
  void submitPhoneNr() async {
    try {
      var verificationId =
          await authService.submitPhoneNumber(phoneNumber: _phoneNr.value);
      _verificationId.inStream(verificationId);
      defineStep(StartUp.confirm);
    } catch (err) {
      defineStep(StartUp.login);
      return;
    }
  }

  void confirmSMSCode() async {
    try {
      await authService.confirmSMSCode(
          verificationId: _verificationId.value, smsCode: _sms.value);
    } catch (err) {
      print('error with confirmation code: ' + err);
    }
    var hasPermission = await requestAccessToCalendar();
    if (!hasPermission) return;
    var currentUser = await userService.getUser();
    if (currentUser.userName == '') {
      defineStep(StartUp.userNameSelect);
      return;
    }
    if (currentUser.calendar != null) {
      defineStep(StartUp.agenda);
      return;
    }
    defineStep(StartUp.calendarSelect);
    return;
  }

  void signOut() {
    authService.signOut().then((_) {
      defineStep(StartUp.login);
    });
    return;
  }

  //Go straight to main page if user logged in + exists in DB

  void checkExistingUserAndCalendar() async {
    //initializing userFromDb with values from empty User returned by service to avoid nested if statements
    User userFromDB = User(userName: '', calendar: null, uid: '');
    print('cursed function starting');
    var userFB = await authService.getCurrentUser();
    if (userFB.uid != null) {
      userFromDB = await userService.getUser();
      print('user received from DB');
    }
    if (userFromDB.userName == '') {
      defineStep(StartUp.userNameSelect);
      return;
    }
    updateUserName(userFromDB.userName);
    if (userFromDB.calendar == null) {
      defineStep(StartUp.calendarSelect);
      return;
    }
    var deviceCalendars = await retrieveCalendars();
    var userCalendar =
        syncCalendarIdWithDevice(deviceCalendars, userFromDB.calendar);
    if (userCalendar != null) {
      _selectedCalendar.value = userCalendar;
      return;
    }
    defineStep(StartUp.calendarSelect);
    return;
  }

  //Necessary for iOS Simulator
  Calendar syncCalendarIdWithDevice(
      List<Calendar> deviceCalendars, Calendar calendarFromDb) {
    for (var calendar in deviceCalendars) {
      if (calendar.name == calendarFromDb.name) return calendar;
    }
    return null;
  }

  //Set user name and create in DB
  void updateUserName(String userName) {
    _userName.value = userName;
    print('username set: ${_userName.value}');
    return;
  }

  //TO DO: use bool to inform user of request's success or failure
  Future<bool> createUserInDB() async {
    try {
      await userService.createUser(_userName.value, _selectedCalendar.value);
      return true;
    } catch (e) {
      print('error creating user: $e');
      return false;
    }
  }

  //Retrieve and select Calendars
  void selectCalendar(Calendar calendar) {
    print('selecting calendar');
    _selectedCalendar.value = calendar;
    print('calendar selected: ${_selectedCalendar.value.id}');
    //defineStep(StartUp.agenda);
    return;
  }

  //gave a return type to be able to use .then()
  Future<List<Calendar>> retrieveCalendars() async {
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    try {
      var hasPermission = await requestAccessToCalendar();
      if (!hasPermission) {
        defineStep(StartUp.login);
        return null;
      }
      Result<List<Calendar>> calendarsResult =
          await _deviceCalendarPlugin.retrieveCalendars();
      _calendars.value = calendarsResult.data;
    } catch (e) {
      print(e);
      return null;
    }
    return _calendars.value;
  }

  dispose() {
    calendarStream.cancel();
    _calendars.dispose();
    _currentStep.dispose();
    _phoneNr.dispose();
    _selectedCalendar.dispose();
    _sms.dispose();
    _userName.dispose();
    _verificationId.dispose();
  }
}

enum StartUp { login, confirm, calendarSelect, userNameSelect, agenda }
