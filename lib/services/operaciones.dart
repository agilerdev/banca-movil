import 'package:cliente/config/config.dart';
import 'package:cliente/shared_preferences/preferencias_usuario.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OperacionesService {
  static Future<Map<String, dynamic>> deposito(String monto) async {
    final _prefs = PreferenciasUsuario();
    try {
      final respuesta = await Dio().post('${Conexion.dev}transaction/deposito',
          data: {
            "monto": monto,
          },
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
      debugPrint(e.message);
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    } catch (e) {
      debugPrint(e.toString());
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    }
  }

  static Future<Map<String, dynamic>> retiro(String monto) async {
    final _prefs = PreferenciasUsuario();
    try {
      final respuesta = await Dio().post('${Conexion.dev}transaction/debito',
          data: {
            "monto": monto,
          },
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
      debugPrint(e.message);
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    } catch (e) {
      debugPrint(e.toString());
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    }
  }

  static Future<Map<String, dynamic>> transferencia(
      String monto, String destinatario) async {
    final _prefs = PreferenciasUsuario();
    try {
      final respuesta = await Dio().post(
          '${Conexion.dev}transaction/transferencia',
          data: {"monto": monto, "cuentaDestino": destinatario},
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
      debugPrint(e.message);
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    } catch (e) {
      debugPrint(e.toString());
      return {'mensajeError': 'Ocurrio un error intentelo mas tarde'};
    }
  }
}
