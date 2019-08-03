import'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/app_bloc.dart';
import 'package:irm_test/bloc_provider.dart';
import 'package:irm_test/login/login_builder.dart';
import 'package:irm_test/login/login_screen.dart';

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
    bloc??=BlocProvider.of(context).appBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamedWidget(
        noDataChild: Container(color:Colors.pink),
        stream: bloc.currentStep,
        builder:(context,snapshot){
          Widget page;
          switch(snapshot.data){
           ///TO DO add a start screen before login
            case StartUp.login:
              page = LoginPageBuilder(step: LoginSteps.phone, context: context)
                  .make();
              break;
            case StartUp.confirm:
              page = LoginPageBuilder(step: LoginSteps.sms, context: context)
                  .make();
              break;
            case StartUp.home:
              page = Container(color:Colors.blue);
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
        }

      ),
    );
  }
}
