import 'package:flutter/material.dart';

class TransferenciaFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String monto = '';
  Map destinatario = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  bool formIsValid() {
    return (formKey.currentState?.validate() ?? false) &&
        destinatario.isNotEmpty;
  }
}
