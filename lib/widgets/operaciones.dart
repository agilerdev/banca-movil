import 'package:cliente/utils/utils.dart';
import 'package:flutter/material.dart';

class Operaciones extends StatelessWidget {
  const Operaciones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _sp = sp(context);
    final List<Widget> ops = [
      Operacion(
        icon: Icon(Icons.add, size: _sp * 15),
        nombre: 'Deposito',
        operacion: () => Navigator.pushNamed(context, 'deposito'),
      ),
      Operacion(
        icon: Icon(Icons.remove, size: _sp * 15),
        nombre: 'Retiro',
        operacion: () => Navigator.pushNamed(context, 'retiro'),
      ),
      Operacion(
        icon: Icon(Icons.compare_arrows, size: _sp * 15),
        nombre: 'Transferencia',
        operacion: () => Navigator.pushNamed(context, 'transferencia'),
      ),
    ];
    return Container(
      width: size.width * 0.8,
      margin: EdgeInsets.only(bottom: size.height * 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Operaciones', style: Theme.of(context).textTheme.headline5),
          Container(
            padding: EdgeInsets.only(top: size.height * 0.03),
            height: size.height * 0.3,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 3,
              children: ops,
            ),
          ),
        ],
      ),
    );
  }
}

class Operacion extends StatelessWidget {
  final Icon icon;
  final String nombre;
  final VoidCallback operacion;
  const Operacion({
    required this.icon,
    required this.nombre,
    required this.operacion,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(4.00),
            onTap: operacion,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: _size.height * 0.01,
                  horizontal: _size.width * 0.05),
              child: icon,
            ),
          ),
        ),
        Text(nombre, style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }
}
