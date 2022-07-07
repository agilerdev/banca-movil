import 'package:cliente/widgets/balance.dart';
import 'package:cliente/widgets/operaciones.dart';
import 'package:cliente/widgets/saludo.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Saludo(),
              Balance(),
              Spacer(),
              Operaciones(),
            ],
          ),
        ),
      ),
    );
  }
}
