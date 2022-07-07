import 'package:cliente/pages/home.dart';
import 'package:cliente/providers/deposito.dart';
import 'package:cliente/providers/login_form.dart';
import 'package:cliente/services/auth.dart';
import 'package:cliente/shared_preferences/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart' as p;

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.10),
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: size.height * 0.10, bottom: 20),
                  width: size.width * 0.30,
                  child: Card(
                    child: p.ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(size: size),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final PreferenciasUsuario _prefs = PreferenciasUsuario();
  _LoginForm({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final loginForm = p.Provider.of<LoginFormProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.only(top: size.height * 0.05),
              child: TextFormField(
                autocorrect: false,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Escriba su correo'),
                  EmailValidator(errorText: 'Correo electrónico invalido'),
                ]),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.blue),
                  labelText: 'Correo',
                  icon: Icon(
                    Icons.person,
                  ),
                  enabled: true,
                ),
                onChanged: (value) {
                  loginForm.correo = value;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.only(top: size.height * 0.02),
              child: TextFormField(
                  autocorrect: false,
                  validator:
                      RequiredValidator(errorText: 'Escriba su contrasena'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.blue),
                    labelText: 'Contraseña',
                    icon: Icon(
                      Icons.lock,
                    ),
                    enabled: true,
                  ),
                  onChanged: (value) {
                    loginForm.password = value;
                  }),
            ),
            Container(
              width: size.width * 0.3,
              height: size.height * 0.05,
              margin: EdgeInsets.only(
                  top: size.height * 0.05, bottom: size.height * 0.05),
              child: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                      onPressed: loginForm.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              if (loginForm.formIsValid()) {
                                loginForm.isLoading = true;

                                final respuesta = await AuthService.login(
                                  loginForm.correo,
                                  loginForm.password,
                                );
                                if (respuesta.containsKey('user')) {
                                  _prefs.sesionIniciada = true;
                                  _prefs.nombreUsuario =
                                      '${respuesta['user']['nombres']} ${respuesta['user']['apellidos']}';
                                  _prefs.numeroCuenta =
                                      '${respuesta['user']['cuenta']['numero']}';
                                  ref.read(balanceProvider.notifier).update(
                                      (state) => respuesta['user']['cuenta']
                                              ['saldo']
                                          .toString());

                                  _prefs.token = respuesta['accessToken'];
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const Home(),
                                      ),
                                      (route) => false);
                                } else {
                                  if (respuesta.containsKey('mensajeBknd')) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Error al iniciar sesión'),
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
                                                Text('Error al iniciar sesión'),
                                            content: Text('Intentelo de nuevo'),
                                          );
                                        });
                                  }
                                }

                                loginForm.isLoading = false;
                              }
                            },
                      child: const Text('Iniciar sesión'));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
