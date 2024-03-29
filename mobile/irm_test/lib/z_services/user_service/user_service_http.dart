import 'dart:convert';
import 'package:device_calendar/device_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:irm_test/services.dart';
import 'package:irm_test/z_services/user_service/user.dart';

class UserServiceHttp extends UserService {
  final String host;
  final AuthService authService;

  UserServiceHttp(this.host, this.authService);

  //TO DO : refactor with getAllUsers to reduce code
  Future<User> getUser() async {
    var user = await authService.getCurrentUser();
    Map<String, String> queryParameters = {'uid': user.uid};

    Uri uri = Uri.http(host, '/getuser', queryParameters);

    var response =
        await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      var userList =
          List<User>.from(jsonBody.map((user) => User.fromJson(user)));
      if (userList.isNotEmpty) {
        User result = userList[0];
        print(result.userName);

        return result;
      }
      return User(
        userName: '',
        calendar: null,
        uid: '',
      );
    }
    print('request done: no user');
    return User(
      userName: '',
      calendar: null,
      uid: '',
    );
  }

  @override
  Future<List<User>> getAllUsers() async {
    Uri uri = Uri.http(host, '/getallusers');
    var response =
        await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      print(jsonBody);
      print(jsonBody.runtimeType);
      if (jsonBody != []) {
        var result =
            List<User>.from(jsonBody.map((user) => User.fromJson(user)));
        return result;
      }
      print('user list empty');
      return null;
    }
    print('request done: no user');

    return null;
  }

  Future<bool> createUser(String userName, Calendar calendar) async {
    var firebaseUser = await authService.getCurrentUser();

    Uri uri = Uri.http(host, '/createuser');

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
