import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set sesionIniciada(bool sesionIniciada) {
    _prefs.setBool('sesionIniciada', sesionIniciada);
  }

  bool get sesionIniciada {
    return _prefs.getBool('sesionIniciada') ?? false;
  }

  String get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? 'Usuario';
  }

  set nombreUsuario(String nombreUsuario) {
    _prefs.setString('nombreUsuario', nombreUsuario);
  }

  set numeroCuenta(String numeroCuenta) {
    _prefs.setString('numeroCuenta', numeroCuenta);
  }

  String get numeroCuenta {
    return _prefs.getString('numeroCuenta') ?? '0';
  }

  set token(String token) {
    _prefs.setString('token', token);
  }

  String get token {
    return _prefs.getString('token') ?? '';
  }

  void borrarPreferencias() {
    _prefs.clear();
  }
}
