import 'package:fl_almagest/providers/register_form_provider.dart';
import 'package:fl_almagest/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../models/cicles.dart';
import '../ui/input_decorations.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 200),
            CardContainer(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Register',
                      style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 20),
                  ChangeNotifierProvider(
                    create: (_) => RegisterFormProvider(),
                    child: const _RegisterForm(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: const Text(
                'Do you have an account',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 50)
          ],
        ),
      )),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    final ciclesService = Provider.of<CiclesService>(context);
    List<Data> ciclos = ciclesService.ciclos;
    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hinText: 'Pepito',
                    labelText: 'Name',
                    prefixIcon: Icons.supervised_user_circle),
                onChanged: (value) => registerForm.name = value,
                validator: (value) {
                  return (value != null && value.length >= 3)
                      ? null
                      : 'Name must have more than 3 characters';
                }),
            const SizedBox(height: 5),
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hinText: 'Perez Perez',
                    labelText: 'Surname',
                    prefixIcon: Icons.supervised_user_circle_outlined),
                onChanged: (value) => registerForm.surname = value,
                validator: (value) {
                  return (value != null && value.length >= 5)
                      ? null
                      : 'Name must have more than 5 characters';
                }),
            const SizedBox(height: 5),
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                  hinText: 'Pepi.to@gmail.com',
                  labelText: 'Email',
                  prefixIcon: Icons.alternate_email_sharp,
                ),
                onChanged: (value) => registerForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Use a valid email';
                }),
            const SizedBox(height: 5),
            TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecorations.authInputDecoration(
                    hinText: '*******',
                    labelText: 'Password',
                    prefixIcon: Icons.lock_open),
                onChanged: (value) => registerForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 2)
                      ? null
                      : 'The password must have more than 6 characters';
                }),
            const SizedBox(height: 5),
            TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecorations.authInputDecoration(
                    hinText: '*******',
                    labelText: 'Confirm Password',
                    prefixIcon: Icons.lock),
                onChanged: (value) => registerForm.c_password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'The password must have more than 6 characters';
                }),
            const SizedBox(height: 5),
            DropdownButtonFormField(
              hint: const Text('Select a cicle'),
              items: ciclos.map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name.toString()),
                );
              }).toList(),
              onChanged: (value) {
                registerForm.cicle_id = value!;
              },
              validator: (value) {
                return (value != null && value != 0) ? null : 'select a cicle';
              },
            ),
            const SizedBox(height: 15),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.blueGrey[600],
              onPressed: registerForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final registerService =
                          Provider.of<RegisterService>(context, listen: false);
                      if (!registerForm.isValidForm()) return;
                      final String? errorMessage =
                          await registerService.register(
                              registerForm.name,
                              registerForm.surname,
                              registerForm.email,
                              registerForm.password,
                              registerForm.c_password,
                              registerForm.cicle_id);
                      if (registerForm.password != registerForm.c_password) {
                        customToast("The passwords don't match", context);
                        registerForm.isLoading = false;
                      } else {
                        if (errorMessage == null) {
                          Navigator.pushReplacementNamed(context, 'login');
                        } else {
                          customToast(
                              'The email is already registered', context);
                          registerForm.isLoading = false;
                        }
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  registerForm.isLoading ? 'Wait' : 'Submit',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void customToast(String message, BuildContext context) {
    showToast(
      message,
      textStyle: const TextStyle(
        fontSize: 14,
        wordSpacing: 0.1,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textPadding: const EdgeInsets.all(23),
      fullWidth: true,
      toastHorizontalMargin: 25,
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.blueGrey[500],
      alignment: Alignment.topCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromBottom,
      context: context,
    );
  }
}
