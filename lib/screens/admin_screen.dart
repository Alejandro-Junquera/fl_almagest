import 'package:fl_almagest/models/models.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'loading_screen.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final authService = Provider.of<AuthService>(context,listen: false);
    List<DataUsers> users = userService.usuarios;
    if(userService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de usuarios: '),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        leading: IconButton(
          icon: Icon(Icons.login_outlined),
          onPressed: (){

            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');

          }
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Slidable(
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              children: const [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.check_circle,
                  label: 'Activar',
                ),
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color.fromARGB(255, 75, 81, 82),
                  foregroundColor: Colors.white,
                  icon: Icons.disabled_by_default_rounded,
                  label: 'Desactivar',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.

                  onPressed: null,
                  backgroundColor: Color.fromARGB(255, 75, 81, 82),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Editar',
                ),
                SlidableAction(
                  onPressed: null,
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
    );
  }

  Widget buildUserListTile(user) => ListTile(
      contentPadding: const EdgeInsets.all(16), title: Text(user.name));
}
