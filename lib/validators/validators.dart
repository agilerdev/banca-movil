import 'package:form_field_validator/form_field_validator.dart';

class DineroValidator extends TextFieldValidator {
  DineroValidator({String errorText = 'Monto inválido'}) : super(errorText);

  @override
  bool get ignoreEmptyValues => true;
  @override
  bool isValid(String? value) {
    if (value == null) {
      return false;
    }
    final reg = RegExp(r'^(\d+)(\.\d{1,2})?$');

    if (reg.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }
}
