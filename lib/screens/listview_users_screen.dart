import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../services/auth_service.dart';

class ListviewUsersScreen extends StatelessWidget {
  // final authService = Provider.of<AuthService>(context, listen: false);
  List<String> users = ['user1', 'user2', 'user3'];
  ListviewUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de usuarios: '),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
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
            endActionPane:  ActionPane(
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
            contentPadding: const EdgeInsets.all(16),
            title: Text('usuario'),
          );

}




        //   children: [
        //     ...users
        //         .map((index) => ListTile(
        //               title: Slidable(
        //                 // The start action pane is the one at the left or the top side.
        //                 startActionPane: ActionPane(
        //                   // A motion is a widget used to control how the pane animates.
        //                   motion: const ScrollMotion(),
        //                   // A pane can dismiss the Slidable.
        //                   dismissible: DismissiblePane(onDismissed: () {}),

        //                   // All actions are defined in the children parameter.
        //                   children: const [
        //                     // A SlidableAction can have an icon and/or a label.
        //                     SlidableAction(
        //                       onPressed: null,
        //                       backgroundColor: Color(0xFF7BC043),
        //                       foregroundColor: Colors.white,
        //                       icon: Icons.check_circle,
        //                       label: 'Activar',
        //                     ),
        //                     SlidableAction(
        //                       onPressed: null,
        //                       backgroundColor: Color.fromARGB(255, 75, 81, 82),
        //                       foregroundColor: Colors.white,
        //                       icon: Icons.disabled_by_default_rounded,
        //                       label: 'Desactivar',
        //                     ),
        //                   ],
        //                 ),

        //                 // The end action pane is the one at the right or the bottom side.
        //                 endActionPane: const ActionPane(
        //                   motion: ScrollMotion(),
        //                   children: [
        //                     SlidableAction(
        //                       // An action can be bigger than the others.

        //                       onPressed: null,
        //                       backgroundColor: Color.fromARGB(255, 75, 81, 82),
        //                       foregroundColor: Colors.white,
        //                       icon: Icons.edit,
        //                       label: 'Editar',
        //                     ),
        //                     SlidableAction(
        //                       onPressed: null,
        //                       backgroundColor: Color(0xFFFE4A49),
        //                       foregroundColor: Colors.white,
        //                       icon: Icons.delete,
        //                       label: 'Eliminar',
        //                     ),
        //                   ],
        //                 ),

        //                 // The child of the Slidable is what the user sees when the
        //                 // component is not dragged.
        //                 child: const ListTile(title: Text('')),
        //               ),
        //             ))
        //         .toList(),
        //   ],
        // ),