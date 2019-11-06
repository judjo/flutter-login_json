import 'package:flutter/material.dart';
import 'login.dart';
import 'list.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new Login(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/list': (context) => ListProduct(),
      },
    );
  }
}