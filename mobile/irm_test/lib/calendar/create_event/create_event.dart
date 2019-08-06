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
  final AppBloc appBloc;
  final CreateEventBloc createEventBloc;

  const CreateEvent(
      {Key key, @required this.appBloc, @required this.createEventBloc})
      : assert(appBloc != null),
        assert(createEventBloc != null),
        super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String dropdownValue;

  //TO DO: see if makes more sense to fetch users
  //in didChangeDep
  @override
  void initState() {
    super.initState();
    widget.createEventBloc.getAllUsersFromDB();
  }

  @override
  void dispose() {
    widget.createEventBloc.dispose();
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
              updater: widget.createEventBloc.updateEventTitle,
            ),
            SizedBox(height: 15),
            FieldString(
              hintTextKey: 'choose a location',
              userData: '',
              labelTextKey: 'location',
              updater: widget.createEventBloc.updateEventLocation,
            ),
            SizedBox(height: 20),
            FieldString(
              hintTextKey: 'describe your event', //TO DO: limit characters
              userData: '',
              labelTextKey: 'Description',
              updater: widget.createEventBloc.updateEventDescription,
            ),
            _dateFields(
              startOrEndDate: 'start date',
              updaterDate: widget.createEventBloc.updateEventStartDate,
              startOrEndTime: 'start time',
              updaterTime: widget.createEventBloc.updateEventStartTime,
            ),
            SizedBox(height: 20),
            _dateFields(
              startOrEndDate: 'end date',
              updaterDate: widget.createEventBloc.updateEventEndDate,
              startOrEndTime: 'end time',
              updaterTime: widget.createEventBloc.updateEventEndTime,
            ),
            SizedBox(height: 20),
            StreamedWidget(
                noDataChild: Container(color: Colors.pink, height: 20),
                stream: widget.createEventBloc.attendeeNames,
                builder: (context, snapshot) {
                  return FieldAttendee(
                    onPressed: null,
                    onChanged: dropdownOnChanged,
                    attendees: snapshot.data,
                    dropdownValue: dropdownValue,
                  );
                }),
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
        stream: widget.appBloc.selectedCalendar,
        builder: (context, calendarSnapshot) {
          return RaisedButton(
            child: Text('save event'),
            //TO DO: prevent multiple button presses for same event
            onPressed: () {
              print('calendarID: ${calendarSnapshot.data.id}');
              widget.createEventBloc.createEvent(calendarSnapshot
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
