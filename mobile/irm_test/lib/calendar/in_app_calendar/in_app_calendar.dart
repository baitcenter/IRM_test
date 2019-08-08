import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/calendar/create_event/create_event.dart';
import 'package:irm_test/calendar/event_details/event_details.dart';
import 'package:irm_test/z_blocs/agenda_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/z_services/calendar_service/extended_event.dart';
import 'package:table_calendar/table_calendar.dart';

class InAppCalendar extends StatefulWidget {
  //final Map<DateTime, List> events;
  final DateTime today;

  const InAppCalendar({Key key, @required this.today})
      : assert(today != null),
        super(key: key);
  @override
  _InAppCalendarState createState() => _InAppCalendarState();
}

class _InAppCalendarState extends State<InAppCalendar>
    with TickerProviderStateMixin {
  List _selectedEvents = [];
  AnimationController _animationController;
  CalendarController _calendarController;
  AgendaBloc _agendaBloc;
  StreamSubscription _eventsListener;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    /*  print(widget.events);
    if (widget.events[widget.today] == null || widget.events == {}) {
      _selectedEvents = [];
    } else {
      _selectedEvents = widget.events[widget.today];
    }*/
    _agendaBloc ??= BlocProvider.of(context).agendaBloc;
    _eventsListener ??= _agendaBloc.events.listen((events) {
      if (events[widget.today] == null) {
        setState(() {
          _selectedEvents = [];
          print("_selectedEvents updated:[]");
        });
      } else {
        setState(() {
          _selectedEvents = events[widget.today];
          print("_selectedEvents updated: not empty");
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    _eventsListener.cancel();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildTableCalendar(),
        const SizedBox(height: 8.0),
        _buildButtons(),
        const SizedBox(height: 8.0),
        Flexible(
          fit: FlexFit.loose,
          child: _buildEventList(),
        ),
      ],
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return StreamedWidget(
        stream: _agendaBloc.events,
        builder: (context, snapshot) {
          return TableCalendar(
            calendarController: _calendarController,
            events: snapshot.data,
            // holidays: widget._holidays,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              selectedColor: Colors.deepOrange[400],
              todayColor: Colors.deepOrange[200],
              markersColor: Colors.brown[700],
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonTextStyle:
                  TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
              formatButtonDecoration: BoxDecoration(
                color: Colors.deepOrange[400],
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            onDaySelected: _onDaySelected,
          );
        });
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text('create meeting'),
          onPressed: () {
            _goToCreateEvent(context);
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents.isNotEmpty
          ? _selectedEvents
              .map((event) => _eventTile(
                    child: ListTile(
                      title: Text(event.title),
                      onTap: () {
                        print('${event.title} tapped!');
                        var extendedEvent =
                            _agendaBloc.retrieveExtendedEvent(event);
                        print(extendedEvent);
                        _goToEventDetails(context, extendedEvent);
                      },
                    ),
                  ))
              .toList()
          : [_eventTile(child: ListTile(title: Text('No event found')))],
    );
  }

  Widget _eventTile({@required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: child,
    );
  }

  void _goToCreateEvent(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateEvent()));
  }

  void _goToEventDetails(BuildContext context, ExtendedEvent extendedEvent) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EventDetails(
              extendedEvent: extendedEvent,
            )));
  }
}
