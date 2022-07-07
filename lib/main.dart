import 'package:cliente/pages/deposito.dart';
import 'package:cliente/pages/home.dart';
import 'package:cliente/pages/login.dart';
import 'package:cliente/pages/retiro.dart';
import 'package:cliente/pages/transferencia.dart';
import 'package:cliente/shared_preferences/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferenciasUsuario prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cliente',
      theme: ThemeData.dark(),
      routes: {
        'home': (context) => const Home(),
        'deposito': (context) => const Deposito(),
        'retiro': (context) => const Retiro(),
        'transferencia': (context) => const Transferencia(),
      },

      // ThemeData(
      //   primarySwatch: Colors.yellow,
      // ),
      home: prefs.sesionIniciada ? const Home() : const Login(),
    );
  }
}
