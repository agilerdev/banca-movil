import 'package:cliente/config/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String correo, String password) async {
    try {
      final respuesta = await Dio().post('${Conexion.dev}user/login', data: {
        "email": correo,
        "contrasena": password,
      });
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
