import 'package:cliente/shared_preferences/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class Saludo extends StatelessWidget {
  const Saludo({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    final prefs = PreferenciasUsuario();
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.04,
      ),
      child: Text(
        'Saludos ${prefs.nombreUsuario}',
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}
