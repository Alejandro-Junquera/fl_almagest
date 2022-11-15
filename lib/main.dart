import 'package:fl_almagest/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserService(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeactivateService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ActivateService(),
        ),
        ChangeNotifierProvider(
          create: (_) => CiclesService(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeleteService(),
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AlmaGest',
        initialRoute: 'login',
        routes: {
          'login': (_) => LoginScreen(),
          'register': (_) => RegisterScreen(),
          'admin': (_) => AdminScreen(),
          'user': (_) => UserScreen(),
        },
        theme: ThemeData.light()
            .copyWith(scaffoldBackgroundColor: Colors.grey[300]));
  }
}
