import 'package:cliente/services/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Transacciones extends ConsumerWidget {
  const Transacciones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final datos = ref.watch(transacProv);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transacciones'),
      ),
      body: datos.when(data: (respuesta) {
        List tran = respuesta['transactions'];
        tran = tran.reversed.toList();
        return ListView.builder(
          itemCount: tran.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    tran[index]['tipo'] == 'deposito'
                        ? Icons.add
                        : tran[index]['tipo'] == 'debito'
                            ? Icons.remove
                            : Icons.compare_arrows,
                  ),
                  title: Text(tran[index]['tipo']),
                  subtitle: Text(tran[index]['monto'].toString()),
                ),
              ),
            );
          }),
        );
      }, error: (context, e) {
        return const Center(
          child: Text('Ha ocurrido un error'),
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

final transacProv = FutureProvider<Map<String, dynamic>>((ref) async {
  return UsersService.obtenerTransacciones();
});
