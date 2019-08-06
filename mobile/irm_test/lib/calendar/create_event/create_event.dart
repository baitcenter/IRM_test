import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:intl/intl.dart';
import 'package:irm_test/calendar/create_event/create_event_bloc.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/widgets/field_attendee.dart';
import 'package:irm_test/widgets/field_date.dart';
import 'package:irm_test/widgets/field_string.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/z_services/service_provider.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  AppBloc _appBloc;
  CreateEventBloc _createEventBloc;
  UserService _userService;
  CalendarService _calendarService;
  String dropdownValue;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _appBloc ??= BlocProvider.of(context).appBloc;
    _userService ??= ServiceProvider.of(context).userService;
    _calendarService ??= ServiceProvider.of(context).calendarService;
    _createEventBloc ??= CreateEventBloc(_userService, _calendarService);
  }

  @override
  void dispose() {
    _createEventBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            FieldString(
              hintTextKey: 'choose a title',
              userData: '',
              labelTextKey: 'Title',
              updater: _createEventBloc.updateEventTitle,
            ),
            SizedBox(height: 15),
            FieldString(
              hintTextKey: 'choose a location',
              userData: '',
              labelTextKey: 'location',
              updater: _createEventBloc.updateEventLocation,
            ),
            SizedBox(height: 20),
            FieldString(
              hintTextKey: 'describe your event', //TO DO: limit characters
              userData: '',
              labelTextKey: 'Description',
              updater: _createEventBloc.updateEventDescription,
            ),
            _dateFields(
              startOrEndDate: 'start date',
              updaterDate: _createEventBloc.updateEventStartDate,
              startOrEndTime: 'start time',
              updaterTime: _createEventBloc.updateEventStartTime,
            ),
            SizedBox(height: 20),
            _dateFields(
              startOrEndDate: 'end date',
              updaterDate: _createEventBloc.updateEventEndDate,
              startOrEndTime: 'end time',
              updaterTime: _createEventBloc.updateEventEndTime,
            ),
            _confirmButton(context),
            //_backButton(context), // TO DO: check redundancy with appBar
          ],
        ),
      ),
    );
  }

  Widget _dateFields(
      {@required String startOrEndDate,
      @required Function updaterDate,
      @required startOrEndTime,
      @required Function updaterTime}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FieldDate(
            format: '00/00/0000',
            controlLength: 10,
            hintTextKey: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            labelTextKey: startOrEndDate,
            userData: '',
            updater: updaterDate,
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          child: FieldDate(
            format: '00:00',
            controlLength: 5,
            hintTextKey: DateFormat('HH:mm').format(DateTime.now()),
            labelTextKey: startOrEndTime,
            userData: '',
            updater: updaterTime,
          ),
        ),
        FieldAttendee(
          onPressed: null,
          onChanged: dropdownOnChanged,
          attendees: null,
          dropdownValue: dropdownValue,
        ),
      ],
    );
  }

  void dropDownOnPressed() {}
  void dropdownOnChanged(String newValue) {
    setState(() {
      dropdownValue = newValue;
    });
  }

  Widget _confirmButton(BuildContext context) {
    return StreamedWidget(
        noDataChild: Container(color: Colors.pink),
        stream: _appBloc.selectedCalendar,
        builder: (context, calendarSnapshot) {
          return RaisedButton(
            child: Text('save event'),
            //TO DO: prevent multiple button presses for same event
            onPressed: () {
              print('calendarID: ${calendarSnapshot.data.id}');
              _createEventBloc.createEvent(calendarSnapshot
                  .data.id); //TO DO:Refactor: export in "builder"
            },
          );
        });
  }

  Widget _backButton(BuildContext context) {
    return RaisedButton(
      child: Text('Go back'),
      onPressed: () {
        _goBack(context);
      },
    );
  }

  void _goBack(BuildContext context) {
    Navigator.of(context).pop();
    return;
  }
}
