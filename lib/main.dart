import 'package:flutter/material.dart';
import 'package:flutter_application/repositories/course_repository.dart';
import 'package:flutter_application/repositories/user_repository.dart';
import 'package:provider/provider.dart';

import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserReposity()),
        ChangeNotifierProvider(create: (context) => CourseRepository())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const LoginPage(),
      ),
    );
  }
}

