import 'dart:async';
import 'package:device_calendar/device_calendar.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:irm_test/services.dart';

class AppBloc {
  final AuthService authService;
  final UserService userService;

  AppBloc(this.authService, this.userService) {
    //Check if user is logged in FB, then check if user and calendar have been set
    //If so go straight to homepage/calendar
    authService.getCurrentUser().then((userFB) {
      if (userFB.uid != null) {
        userService.getUser().then((user) {
          print('user received');
          if (user.userName == '') {
            defineStep(StartUp.userNameSelect);
          } else {
            updateUserName(user.userName);
          }
          if (user.userName != '' && user.calendar != null) {
            selectCalendar(user.calendar);
          }
        });
      }
    });
    //TO DO: refactor to delete this (legacy) listener
    calendarStream = selectedCalendar.listen((calendar) {
      if (calendar != null) {
        defineStep(StartUp.agenda);
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

  //Authentication
  void inputSMS(String userInput) {
    _sms.inStream(userInput);
    print('sms input');
  }

  void inputPhoneNr(String userInput) {
    _phoneNr.inStream(userInput);
    print('phone input');
    return;
  }

  ///TO DO prevent multiple clicking on button (add bool "is_loading")
  void submitPhoneNr() async {
    try {
      var verificationId =
          await authService.submitPhoneNumber(phoneNumber: _phoneNr.value);
      print('verification id received');
      _verificationId.inStream(verificationId);
      print('stream added');
      defineStep(StartUp.confirm);
    } catch (err) {
      print('shit hit the fan');
      defineStep(StartUp.login);
      return;
    }
  }

  void confirmSMSCode() async {
    try {
      await authService.confirmSMSCode(
          verificationId: _verificationId.value, smsCode: _sms.value);
      defineStep(StartUp.agenda);
    } catch (err) {
      print('error with confirmation code: ' + err);
    }
    return;
  }

  void signOut() {
    authService.signOut().then((_) {
      defineStep(StartUp.login);
    });
    return;
  }

  //Set user name and create in DB
  void updateUserName(String userName) {
    _userName.value = userName;
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
    _selectedCalendar.value = calendar;
    return;
  }

  void retrieveCalendars() async {
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
      _calendars.value = calendarsResult.data;
    } catch (e) {
      print(e);
    }
    return;
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
