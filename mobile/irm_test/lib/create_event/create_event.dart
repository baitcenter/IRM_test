import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/blocs/agenda_bloc.dart';
import 'package:irm_test/blocs/bloc_provider.dart';
import 'package:irm_test/blocs/calendar_bloc.dart';
import 'package:irm_test/widgets/field_string.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  AgendaBloc _agendaBloc;
  CalendarBloc _calendarBloc;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _agendaBloc ??= BlocProvider.of(context).agendaBloc;
    _calendarBloc ??= BlocProvider.of(context).calendarBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          FieldString(
            hintTextKey: 'choose a title',
            userData: '',
            labelTextKey: 'Title',
            updater: _calendarBloc.updateEventTitle,
          ),
          SizedBox(height: 15),
          FieldString(
            hintTextKey: 'choose a location',
            userData: '',
            labelTextKey: 'location',
            updater: _calendarBloc.updateEventLocation,
          ),
          SizedBox(height: 20),
          _confirmButton(),
          _backButton(context),
        ],
      ),
    );
  }

  Widget _confirmButton() {
    return StreamedWidget(
        stream: _agendaBloc.selectedCalendar,
        builder: (context, snapshot) {
          return RawMaterialButton(
            child: Text('save event'),
            onPressed: () {
              print('calendarID: ${snapshot.data.id}');
              _calendarBloc.createEvent(
                  snapshot.data.id); //Refactor: export in "builder"
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
