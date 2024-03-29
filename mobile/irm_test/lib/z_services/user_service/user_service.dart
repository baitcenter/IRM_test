import 'package:device_calendar/device_calendar.dart';
import 'package:irm_test/z_services/user_service/user.dart';

abstract class UserService {
  Future<User> getUser();
  Future<bool> createUser(String userName, Calendar calendar);
  Future<List<User>> getAllUsers();
}
