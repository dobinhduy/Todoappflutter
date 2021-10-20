import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:test/pages/add_to_do.dart';
import 'package:test/pages/home_page.dart';
import 'package:test/pages/sign_up_page.dart';
import 'package:test/service/auth_services.dart';

//  flutter run -d chrome --web-hostname localhost --web-port 5000
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  bool kisweb;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      kisweb = false;
    } else {
      kisweb = true;
    }
  } catch (e) {
    kisweb = true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = const SignUpPage();
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String token = await authClass.getToken() as String;

    setState(() {
      currentPage = const HomePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: currentPage,
    );
  }
}
