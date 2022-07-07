import 'package:flutter/material.dart';

class DepositoFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String monto = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  bool formIsValid() {
    return formKey.currentState?.validate() ?? false;
  }
}
