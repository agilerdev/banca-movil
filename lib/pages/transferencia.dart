import 'package:cliente/pages/seleccion_beneficiario.dart';
import 'package:cliente/providers/deposito.dart';
import 'package:cliente/providers/transferencia_form.dart';
import 'package:cliente/services/operaciones.dart';
import 'package:cliente/utils/utils.dart';
import 'package:cliente/widgets/balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

class Transferencia extends StatefulWidget {
  const Transferencia({Key? key}) : super(key: key);

  @override
  State<Transferencia> createState() => _TransferenciaState();
}

class _TransferenciaState extends State<Transferencia> {
  Map usuario = {};
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final reg = RegExp(
      r'^\d+\.?\d{0,2}',
    );
    final _sp = sp(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferir'),
      ),
      body: Center(
        child: p.ChangeNotifierProvider(
          create: (_) => TransferenciaFormProvider(),
          builder: (context, widget) {
            final transferenciaForm =
                p.Provider.of<TransferenciaFormProvider>(context);
            return Form(
              key: transferenciaForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.1, top: size.height * 0.05),
                    child: Text(
                      'Ingrese el monto a transferir',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      bottom: size.height * 0.05,
                      top: size.height * 0.05,
                    ),
                    child: Card(
                      child: Container(
                        width: size.width * 0.4,
                        padding: EdgeInsets.only(
                          left: size.width * 0.02,
                          right: size.width * 0.02,
                          bottom: size.height * 0.03,
                          top: size.height * 0.03,
                        ),
                        child: TextFormField(
                          onChanged: (nuevoValor) {
                            transferenciaForm.monto = nuevoValor;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '\$0.00',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              reg,
                            ),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.1, top: size.height * 0.0),
                    child: Text(
                      'Su saldo:',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      top: size.height * 0.05,
                    ),
                    child: SizedBox(
                      width: size.width * 0.405,
                      child: const Balance(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.1, top: size.height * 0.05),
                    child: Text(
                      'Escoja el beneficiario:',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                      bottom: size.height * 0.05,
                      top: size.height * 0.05,
                    ),
                    child: Card(
                      child: InkWell(
                        onTap: () async {
                          transferenciaForm.destinatario =
                              (await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const SeleccionBeneficiario(),
                                      )))![0] ??
                                  {};
                          usuario = transferenciaForm.destinatario;
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(4.00),
                        child: Container(
                          width: size.width * 0.4,
                          padding: EdgeInsets.only(
                            left: size.width * 0.02,
                            right: size.width * 0.02,
                            bottom: size.height * 0.03,
                            top: size.height * 0.03,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, size: _sp * 11),
                              usuario.isEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.01),
                                      child: const Text(
                                        'Beneficiario',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.01),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${usuario['nombres']} ${usuario['apellidos']}',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            usuario['email'],
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.1,
                    ),
                    width: size.width * 0.7,
                    height: size.height * 0.08,
                    child: Consumer(builder: (context, ref, widget) {
                      return ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (transferenciaForm.formIsValid()) {
                            transferenciaForm.isLoading = true;

                            final respuesta =
                                await OperacionesService.transferencia(
                                    transferenciaForm.monto,
                                    transferenciaForm.destinatario['cuenta']
                                        ['numero']);

                            if (respuesta.containsKey('cuenta')) {
                              // ignore: use_build_context_synchronously
                              ref.read(balanceProvider.notifier).update(
                                  (state) =>
                                      respuesta['cuenta']['saldo'].toString());

                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const SimpleDialog(
                                      title: Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 75,
                                          color: Colors.green,
                                        ),
                                      ),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Center(
                                            child: Text(
                                                'Transaccion completada con exito',
                                                style: TextStyle(fontSize: 25)),
                                          ),
                                        )
                                      ],
                                    );
                                  });

                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } else {
                              if (respuesta.containsKey('mensajeBknd')) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Error realizar transferencia'),
                                        content: Text(respuesta['mensajeBknd']),
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        title: Text(
                                            'Error realizar transferencia'),
                                        content: Text('Intentelo de nuevo'),
                                      );
                                    });
                              }
                            }

                            transferenciaForm.isLoading = false;
                          }
                        },
                        child: const Text('Transferir',
                            style: TextStyle(fontSize: 25)),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
