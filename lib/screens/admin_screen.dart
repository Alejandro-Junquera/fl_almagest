import 'package:fl_almagest/models/models.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'loading_screen.dart';

Future refresh(BuildContext context) async {
  users0.clear();
  final userService = Provider.of<UserService>(context, listen: false);
  userService.getUsers();
}

List<DataUsers> users0 = [];

class AdminScreen extends StatelessWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final deleteService = Provider.of<DeleteService>(context, listen: false);
    final deactivateService =
        Provider.of<DeactivateService>(context, listen: false);
    final activateService =
        Provider.of<ActivateService>(context, listen: false);
    users0 = userService.usuarios;
    List<DataUsers> users = [];
    for (var i in users0) {
      if (i.deleted == 0) {
        users.add(i);
      }
    }
    if (userService.isLoading) return LoadingScreen();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de usuarios: '),
          backgroundColor: Color.fromRGBO(63, 63, 156, 1),
          leading: IconButton(
              icon: Icon(Icons.login_outlined),
              onPressed: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              }),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            refresh(context);
            Navigator.pushReplacementNamed(context, 'admin');
          },
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              bool siActivo;
              bool noActivo;
              if (user.actived == 1) {
                siActivo = false;
                noActivo = true;
              } else {
                siActivo = true;
                noActivo = false;
              }
              return Slidable(
                startActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    Visibility(
                      child: SlidableAction(
                        onPressed: (context) {
                          customToast('User activated', context);
                          activateService.activate(user.id.toString());
                          user.actived = 1;
                          final msg = activateService.mensaje;
                          Navigator.pushReplacementNamed(context, 'admin');
                        },
                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.check_circle,
                        label: 'Activar',
                      ),
                      visible: siActivo,
                    ),
                    Visibility(
                      child: SlidableAction(
                        onPressed: (context) {
                          customToast('User deactivated', context);
                          deactivateService.deactivate(user.id.toString());
                          user.actived = 0;
                          final msg = deactivateService.mensaje;
                          Navigator.pushReplacementNamed(context, 'admin');
                        },
                        backgroundColor: Color.fromARGB(255, 75, 81, 82),
                        foregroundColor: Colors.white,
                        icon: Icons.disabled_by_default_rounded,
                        label: 'Desactivar',
                      ),
                      visible: noActivo,
                    )
                  ],
                ),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    // SlidableAction(
                    //   // An action can be bigger than the others.

                    //   onPressed: null,
                    //   backgroundColor: Color.fromARGB(255, 75, 81, 82),
                    //   foregroundColor: Colors.white,
                    //   icon: Icons.edit,
                    //   label: 'Editar',
                    // ),
                    SlidableAction(
                      onPressed: (context) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Delete user'),
                            content: const Text('Are you sure?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, 'admin'),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteService.delete(user.id.toString());
                                  user.deleted = 1;
                                  final msg = deleteService.mensaje;
                                  Navigator.pushReplacementNamed(
                                      context, 'admin');
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                        /*deleteService.delete(user.id.toString());
                  user.deleted=1;
                  final msg = deleteService.mensaje; 
                  Navigator.pushReplacementNamed(context, 'admin');*/
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Eliminar',
                    ),
                  ],
                ),
                child: buildUserListTile(user),
              );
            },
          ),
        ));
  }

  Widget buildUserListTile(user) => ListTile(
      contentPadding: const EdgeInsets.all(16), title: Text(user.name));

  void customToast(String message, BuildContext context) {
    showToast(
      message,
      textStyle: const TextStyle(
        fontSize: 14,
        wordSpacing: 0.1,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      textPadding: const EdgeInsets.all(23),
      fullWidth: true,
      toastHorizontalMargin: 25,
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.indigo,
      alignment: Alignment.topCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromBottom,
      context: context,
    );
  }
}