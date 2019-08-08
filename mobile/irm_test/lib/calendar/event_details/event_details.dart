import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/calendar/event_details/event_details_bloc.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/utils/utils.dart';
import 'package:irm_test/z_blocs/agenda_bloc.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';

class EventDetails extends StatefulWidget {
  final ExtendedEvent extendedEvent;

  const EventDetails({Key key, @required this.extendedEvent})
      : assert(extendedEvent != null),
        super(key: key);
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String dropdownValue;
  UserService _userService;
  AppBloc _appBloc;
  AgendaBloc _agendaBloc;
  CalendarService _calendarService;
  EventDetailsBloc _eventDetailsBloc;

  @override
  void didChangeDependencies() {
    print(widget.extendedEvent.event.title);
    super.didChangeDependencies();
    _appBloc ??= BlocProvider.of(context).appBloc;
    _agendaBloc ??= BlocProvider.of(context).agendaBloc;
    _userService ??= ServiceProvider.of(context).userService;
    _calendarService ??= ServiceProvider.of(context).calendarService;
    _eventDetailsBloc ??=
        EventDetailsBloc(_appBloc, _calendarService, _agendaBloc);
  }

  @override
  void dispose() {
    super.dispose();
    _eventDetailsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(child: Text('TITLE')),
            Container(child: Text('LOCATION')),
            Container(child: Text('DESCRIPTION')),
            Container(child: Text('START DATE')),
            Container(child: Text('START TIME')),
            Container(child: Text('END DATE')),
            Container(child: Text('END TIME')),
            Container(child: Text('ATTENDEES WITH STATUS')),
            _updateButton(context),
          ],
        ),
      ),
    );
  }

  //TO DO: make user status function in BloC
  Widget _updateButton(BuildContext context) {
    return StreamedWidget(
        stream: _eventDetailsBloc.user,
        builder: (context, snapshot) {
          if (MyUtils.isUserOwner(widget.extendedEvent, snapshot.data)) {
            return RaisedButton(
              child: Text('delete event'),
              onPressed: () async {
                _eventDetailsBloc.deleteEvent(widget.extendedEvent).then((_) {
                  Navigator.of(context).pop();
                });
              },
            );
          }
          return Column(
            children: <Widget>[
              Container(child: Text('Participation status')),
              RaisedButton(child: Text('Accept')),
              RaisedButton(child: Text('Decline')),
            ],
          );
        });
  }
}
