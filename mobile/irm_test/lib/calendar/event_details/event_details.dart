import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:intl/intl.dart';
import 'package:irm_test/calendar/event_details/event_details_bloc.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/utils/utils.dart';
import 'package:irm_test/z_blocs/agenda_bloc.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';
import 'package:irm_test/z_services/calendar_service/guest.dart';

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
            ListTile(
                title: Text(widget.extendedEvent.event.title),
                leading: Text('Title')),
            ListTile(title: Text('LOCATION')),
            ListTile(
                title: Text(widget.extendedEvent.event.description),
                leading: Text('Description')),
            ListTile(
                title: Text(DateFormat('dd/MM/yyyy')
                    .format(widget.extendedEvent.event.start)),
                leading: Text('Start Date')),
            ListTile(
                title: Text(DateFormat('HH:mm')
                    .format(widget.extendedEvent.event.start)),
                leading: Text('Start Time')),
            ListTile(
                title: Text(DateFormat('dd/MM/yyyy')
                    .format(widget.extendedEvent.event.end)),
                leading: Text('End Date')),
            ListTile(
                title: Text(
                    DateFormat('HH:mm').format(widget.extendedEvent.event.end)),
                leading: Text('End Time')),
            ListTile(title: _attendeeList(), leading: Text('Attendees')),
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
              ListTile(
                leading: Text('Your RSVP'),
                title: _rsvp(widget.extendedEvent.guests, snapshot.data),
              ),
              RaisedButton(child: Text('Accept')),
              RaisedButton(child: Text('Decline')),
            ],
          );
        });
  }

  Widget _rsvp(List<Guest> guests, User user) {
    var userAsGuest = guests.firstWhere((guest) {
      return guest.name == user.userName;
    });

    String rsvp;
    switch (userAsGuest.isAttending) {
      case 1:
        rsvp = 'To be confirmed';
        break;
      case 2:
        rsvp = 'Not attending';
        break;
      case 3:
        rsvp = 'Attending';
        break;
      default:
        rsvp = 'To be confirmed';
        break;
    }
    return Text(rsvp);
  }

  Widget _attendeeList() {
    var attendees = widget.extendedEvent.guests;
    return Column(
      children: attendees.isNotEmpty
          ? _buildAttendeeList(attendees)
          : <Widget>[Text('No Guests for this event')],
    );
  }

  List<Widget> _buildAttendeeList(List<Guest> guests) {
    return guests.map((guest) {
      Widget guestEntry;
      switch (guest.isAttending) {
        case 1:
          guestEntry = Row(
            children: <Widget>[
              Container(child: Text(guest.name)),
              Container(child: Text('Not confirmed yet')),
            ],
          );
          break;
        case 2:
          guestEntry = Row(
            children: <Widget>[
              Container(child: Text(guest.name)),
              Container(child: Text('Not Attending')),
            ],
          );
          break;
        case 3:
          guestEntry = Row(
            children: <Widget>[
              Container(child: Text(guest.name)),
              Container(child: Text('Not confirmed yet')),
            ],
          );
          break;
        default:
          guestEntry = Row(
            children: <Widget>[
              Container(child: Text(guest.name)),
              Container(child: Text('Not confirmed yet')),
            ],
          );
          break;
      }
      return guestEntry;
    }).toList();
  }
}
