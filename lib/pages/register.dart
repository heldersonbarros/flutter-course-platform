import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/repositories/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final items = ['Estudante', 'Instrutor'];
  String? choosen;

  @override
  void initState() {
    final controller = context.read<UserReposity>();
    controller.addListener(() {
      if (controller.state == AuthState.success) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
      } else if (controller.state == AuthState.invalid) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserReposity>();

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.indigo
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                    TextField(
                      controller: usernameController,
                      decoration:
                          const InputDecoration(label: Text("Username")),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(label: Text("Email")),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(label: Text("Password")),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                    DropdownButton<String>(
                        hint: const Text("Selecione uma opção"),
                        items: items
                            .map(
                              (item) => DropdownMenuItem(
                                child: Text(item),
                                value: item,
                              ),
                            )
                            .toList(),
                        value: choosen,
                        onChanged: (value) {
                          setState(() {
                            choosen = value;
                          });
                        }),
                  const SizedBox(
                    height: 30,
                  ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () =>
                            controller.register(usernameController.text, emailController.text, passwordController.text, choosen?? ""),
                          child: const Text("Register Account")),
                    )
                  ]),
            )),
      ),
    );
  }

  void register() async {
    var response =
      await http.post(Uri.parse("http://10.0.0.137:8000/register"), body: jsonEncode(
        {
      "username": usernameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "is_instructor": choosen == "Instrutor" ? true : false
      }), headers: {"content-type": "application/json"});

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const DashboardPage()));

      await sharedPreferences.setString("token", body["token"]);
      await sharedPreferences.setInt("user_id", body["user_id"]);
      await sharedPreferences.setString("is_instructor", body["is_instructor"].toString());

    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
    }
  }
}
