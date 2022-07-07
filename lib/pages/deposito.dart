import 'package:cliente/pages/transacciones.dart';
import 'package:cliente/providers/deposito.dart';
import 'package:cliente/providers/deposito_form.dart';
import 'package:cliente/services/operaciones.dart';
import 'package:cliente/services/users.dart';
import 'package:cliente/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart' as p;

class Deposito extends StatelessWidget {
  const Deposito({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reg = RegExp(
      r'^\d+(\.\d{0,2})?',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposito'),
      ),
      body: Center(
        child: p.ChangeNotifierProvider(
          create: (_) => DepositoFormProvider(),
          child: _DepositoForm(size: size, reg: reg),
        ),
      ),
    );
  }
}

class _DepositoForm extends ConsumerWidget {
  const _DepositoForm({
    Key? key,
    required this.size,
    required this.reg,
  }) : super(key: key);

  final Size size;
  final RegExp reg;

  @override
  Widget build(BuildContext context, ref) {
    final depositoForm = p.Provider.of<DepositoFormProvider>(context);
    return Form(
      key: depositoForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.1, top: size.height * 0.05),
            child: Text(
              'Ingrese el valor a depositar',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Row(
            children: [
              Container(
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '\$0.00',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          reg,
                        ),
                      ],
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Ingrese un monto'),
                        DineroValidator(),
                      ]),
                      onChanged: (valor) {
                        depositoForm.monto = valor;
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                    ),
                  ))),
              SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.08,
                child: ElevatedButton(
                    onPressed: depositoForm.isLoading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            if (depositoForm.formIsValid()) {
                              depositoForm.isLoading = true;

                              final respuesta =
                                  await OperacionesService.deposito(
                                      depositoForm.monto);

                              if (respuesta.containsKey('cuenta')) {
                                // ignore: use_build_context_synchronously
                                ref.read(balanceProvider.notifier).update(
                                    (state) => respuesta['cuenta']['saldo']
                                        .toString());

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
                                                  style:
                                                      TextStyle(fontSize: 25)),
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
                                              'Error realizar deposito'),
                                          content:
                                              Text(respuesta['mensajeBknd']),
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          title:
                                              Text('Error realizar deposito'),
                                          content: Text('Intentelo de nuevo'),
                                        );
                                      });
                                }
                              }

                              depositoForm.isLoading = false;
                            }
                          },
                    child: const Text(
                      'Depositar',
                      style: TextStyle(fontSize: 15),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
