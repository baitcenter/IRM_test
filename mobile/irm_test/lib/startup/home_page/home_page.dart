import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/startup/agenda/agenda.dart';
import 'package:irm_test/startup/calendar_select/calendar_select.dart';
import 'package:irm_test/startup/login/login_builder.dart';
import 'package:irm_test/startup/login/login_screen.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/startup/username_select/username_select.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppBloc bloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    bloc ??= BlocProvider.of(context).appBloc;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Hello'),
        ),
        body: StreamedWidget(
            noDataChild: Container(color: Colors.pink),
            stream: bloc.currentStep,
            builder: (context, snapshot) {
              Widget page;
              switch (snapshot.data) {

                ///TO DO add a start screen before a_startup.login
                case StartUp.login:
                  page =
                      LoginPageBuilder(step: LoginSteps.phone, context: context)
                          .make();
                  break;
                case StartUp.confirm:
                  page =
                      LoginPageBuilder(step: LoginSteps.sms, context: context)
                          .make();
                  break;
                case StartUp.userNameSelect:
                  page = UserNameSelect();
                  break;
                case StartUp.calendarSelect:
                  page = CalendarSelect();
                  break;
                case StartUp.agenda:
                  page = Agenda();
                  // page = CalendarSample();
                  break;
                default:
                  page = Container(
                      color: Colors.grey,
                      child: Center(
                        child: Text(
                            'If you work hard, your dreams still may not come true'),
                      ));
                  break;
              }
              return page;
            }),
      ),
    );
  }
}
