import 'package:cliente/pages/transacciones.dart';
import 'package:cliente/providers/deposito.dart';
import 'package:cliente/services/users.dart';
import 'package:cliente/shared_preferences/preferencias_usuario.dart';
import 'package:cliente/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Balance extends ConsumerWidget {
  const Balance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    String balance = ref.watch(balanceProvider);
    Size size = MediaQuery.of(context).size;
    final prefs = PreferenciasUsuario();
    AsyncValue datosP = ref.watch(balProv);
    final _sp = sp(context);
    return datosP.when(data: (data) {
      return Card(
        child: InkWell(
          onTap: () {
            ref.refresh(transacProv);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const Transacciones()));
          },
          child: Container(
            width: size.width * 0.8,
            padding: EdgeInsets.only(
              top: size.height * 0.02,
              bottom: size.height * 0.03,
              left: size.width * 0.02,
              right: size.width * 0.02,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cuenta Nro. ${prefs.numeroCuenta}',
                        style: const TextStyle(fontSize: 16)),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.credit_card),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Saldo: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$ $balance',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }, error: (context, e) {
      print(e);
      return const Center(
        child: Text('Ha ocurrido un error'),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}

final balProv = FutureProvider((ref) async {
  await UsersService.obtenerDatos().then((respuesta) {
    final cuenta = respuesta['user']['cuenta'];
    ref
        .read(balanceProvider.notifier)
        .update((state) => cuenta['saldo'].toString());
    return;
  });
});
