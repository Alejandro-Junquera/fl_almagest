import 'package:fl_almagest/models/models.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'loading_screen.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final userService = UserService();
  List<DataUsers> users = [];
  Future refresh() async {
    setState(() => users.clear());
    final userService = Provider.of<UserService>(context, listen: false);
    await userService.getUsers();
    setState(() {
      users = userService.usuarios;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final deleteService = Provider.of<DeleteService>(context, listen: false);
    final deactivateService =
        Provider.of<DeactivateService>(context, listen: false);
    final activateService =
        Provider.of<ActivateService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de usuarios: '),
          backgroundColor: Colors.blueGrey[800],
          leading: IconButton(
              icon: Icon(Icons.login_outlined),
              onPressed: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              }),
        ),
        body: users.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: refresh,
                child: ListView.separated(
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
                    return Container(
                      color: Colors.grey[300],
                      child: Slidable(
                        startActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            Visibility(
                              child: SlidableAction(
                                onPressed: (context) {
                                  customToast(
                                      'User ' +
                                          users[index].name.toString() +
                                          ' activated',
                                      context);
                                  activateService.activate(user.id.toString());
                                  setState(() {
                                    users[index].actived = 1;
                                  });
                                  final msg = activateService.mensaje;
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
                                  customToast(
                                      'User ' +
                                          users[index].name.toString() +
                                          ' deactivated',
                                      context);
                                  deactivateService
                                      .deactivate(user.id.toString());
                                  setState(() {
                                    users[index].actived = 0;
                                  });
                                  final msg = deactivateService.mensaje;
                                },
                                backgroundColor:
                                    Color.fromARGB(255, 75, 81, 82),
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
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Delete user'),
                                    content: const Text('Are you sure?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          customToast(
                                              'User ' +
                                                  users[index].name.toString() +
                                                  ' deleted ',
                                              context);
                                          deleteService
                                              .delete(user.id.toString());
                                          setState(() {
                                            users.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                          final msg = deleteService.mensaje;
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
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 1,
                      color: Colors.blueGrey[800],
                    );
                  },
                ),
              ));
  }

  Widget buildUserListTile(user) => ListTile(
      leading: Icon(
        Icons.account_box_rounded,
        size: 50,
      ),
      contentPadding: const EdgeInsets.all(16),
      title: Text(user.name + ' ' + user.surname),
      subtitle: Text(user.email));

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
