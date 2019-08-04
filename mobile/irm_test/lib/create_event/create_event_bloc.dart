//this bloc manages button states to avoid for example double inputs
import 'package:frideos_core/frideos_core.dart';

class CreateEventBloc {
  var _buttonPressed = StreamedValue<bool>()..value = false;

  Stream<bool> get isButtonPressed => _buttonPressed.outStream;
  void pressButtonState() {
    _buttonPressed.value = !_buttonPressed.value;
    return;
  }

  dispose() {
    _buttonPressed.dispose();
  }
}
