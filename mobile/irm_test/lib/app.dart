import 'package:flutter/material.dart';
import 'package:irm_test/app_bloc.dart';
import 'package:irm_test/bloc_provider.dart';
import 'package:irm_test/home_page/home_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ///TO DO: test Boelens' implementation of BlocProvider
  AppBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc ??= BlocProvider.of(context).appBloc;
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
      theme: ThemeData.dark(),
    );
  }
}
