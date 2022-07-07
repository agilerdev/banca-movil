import 'package:cliente/config/config.dart';
import 'package:cliente/shared_preferences/preferencias_usuario.dart';
import 'package:dio/dio.dart';

class UsersService {
  static Future<Map<String, dynamic>> obtenerUsuarios() async {
    final _prefs = PreferenciasUsuario();
    try {
      final respuesta = await Dio().get('${Conexion.dev}user/all',
          options:
              Options(headers: {'authorization': 'Bearer ${_prefs.token}'}));
      return respuesta.data;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        final resp = e.response!;
        if ((resp.data as Map).containsKey('mensajeBknd')) {
          return resp.data;
        }
      }
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    } catch (e) {
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    }
  }

  static Future<Map<String, dynamic>> obtenerDatos() async {
    final _prefs = PreferenciasUsuario();
    try {
      final respuesta = await Dio().get('${Conexion.dev}user/data',
          options:
              Options(headers: {'authorization': 'Bearer ${_prefs.token}'}));
      return respuesta.data;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        final resp = e.response!;
        if ((resp.data as Map).containsKey('mensajeBknd')) {
          return resp.data;
        }
      }
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    } catch (e) {
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    }
  }

  static Future<Map<String, dynamic>> obtenerTransacciones() async {
    final _prefs = PreferenciasUsuario();
    final respuesta = await Dio().get(
        '${Conexion.dev}transaction/userTransactions',
        options: Options(headers: {'authorization': 'Bearer ${_prefs.token}'}));
    return respuesta.data;
  }
}
