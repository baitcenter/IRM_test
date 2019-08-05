import 'package:frideos_core/frideos_core.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/services/user_service/user.dart';

class CreateEventBloc {
  final UserService userService;

  CreateEventBloc(this.userService) {
    getAllUsersFromDB();
  }

  var _allUsers = StreamedValue<List<User>>();
  var _buttonPressed = StreamedValue<bool>()..value = false;

  Stream<List<User>> get allUsers => _allUsers.outStream;
  Stream<bool> get isButtonPressed => _buttonPressed.outStream;

  void pressButtonState() {
    _buttonPressed.value = !_buttonPressed.value;
    return;
  }

  void getAllUsersFromDB() async {
    try {
      var users = await userService.getAllUsers();
      _allUsers.value = users;
      print('all users: ${_allUsers.value}');
      return;
    } catch (e) {
      print('error fetching users: $e');
      return;
    }
  }

  dispose() {
    _buttonPressed.dispose();
    _allUsers.dispose();
  }
}
