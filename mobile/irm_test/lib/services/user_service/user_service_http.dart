import 'dart:convert';
import 'package:device_calendar/device_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:irm_test/services.dart';
import 'package:irm_test/services/user_service/user.dart';

class UserServiceHttp extends UserService {
  final String host;
  final AuthService authService;

  UserServiceHttp(this.host, this.authService);

  Future<User> getUser() async {
    var user = await authService.getCurrentUser();

    Uri uri = Uri.https(host, '/getuser?uid=${user.uid}');

    print('sending get request');

    var response =
        await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      var user = User.fromJson(jsonBody);
      print('request ok, sending user');
      return user;
    }
    print('request done: no user');
    return User(
      userName: '',
      calendar: null,
      uid: '',
    );
  }

  Future<bool> createUser(String userName, Calendar calendar) async {
    var firebaseUser = await authService.getCurrentUser();

    Uri uri = Uri.https(host, '/createuser');

    var calendarJson = calendar.toJson();

    var response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "userName": userName,
          "calendar": calendarJson,
          "uid": firebaseUser.uid
        }));

    if (response.statusCode == 200 && response.statusCode <= 300) {
      return true;
    }
    return false;
  }
}
