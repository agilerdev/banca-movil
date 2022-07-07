import 'package:cliente/services/users.dart';
import 'package:cliente/shared_preferences/preferencias_usuario.dart';
import 'package:cliente/utils/utils.dart';
import 'package:flutter/material.dart';

class SeleccionBeneficiario extends StatefulWidget {
  const SeleccionBeneficiario({Key? key}) : super(key: key);

  @override
  State<SeleccionBeneficiario> createState() => _SeleccionBeneficiarioState();
}

class _SeleccionBeneficiarioState extends State<SeleccionBeneficiario> {
  late Future<Map<String, dynamic>> _obtenerUsuarios;
  @override
  void initState() {
    super.initState();
    _obtenerUsuarios = UsersService.obtenerUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _sp = sp(context);
    final _prefs = PreferenciasUsuario();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beneficiario'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: _obtenerUsuarios,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: TextButton(
                      child: const Text(
                          'Ha ocurrido un error vuelva a intentarlo'),
                      onPressed: () {
                        setState(() {
                          _obtenerUsuarios = UsersService.obtenerUsuarios();
                        });
                      }),
                );
              }
              final Map<String, dynamic> datos =
                  snapshot.data as Map<String, dynamic>;
              Map usuario = datos['users'][0];
              if (datos == null || datos.isEmpty) {
                return const Center(
                  child: Text('No existen usuarios'),
                );
              }
              final List users = datos['users'];
              users.removeWhere(
                (element) {
                  return _prefs.numeroCuenta == element['cuenta']['numero'];
                },
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: double.infinity),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.1, top: size.height * 0.05),
                    child: Text(
                      'Seleccione el beneficiario',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.7,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: ((context, index) {
                          final usuario = users[index];
                          final cuenta = usuario['cuenta'];
                          return Container(
                            // width: size.width * 0.1,
                            padding: EdgeInsets.only(
                                left: size.width * 0.1,
                                top: size.height * 0.03,
                                right: size.width * 0.1),
                            child: Card(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4.00),
                                onTap: () => Navigator.pop(context, [usuario]),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: size.width * 0.05,
                                    top: size.height * 0.03,
                                    bottom: size.height * 0.03,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cuenta Nro. ${cuenta["numero"]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: _sp * 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${usuario['nombres']} ${usuario['apellidos']}',
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  usuario['email'],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
                  )
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
