import 'package:flutter/material.dart';
import 'package:flutter_application/pages/dashboard.dart';
import 'package:flutter_application/pages/register.dart';
import 'package:flutter_application/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState(){
    super.initState();
    final controller = context.read<UserReposity>();
    controller.addListener(() {
      if (controller.state == AuthState.success){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
      } else if (controller.state == AuthState.invalid){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
      } else if (controller.state == AuthState.error){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Blank Value Found")));
      }
    });
    checklogin();
  }

  void checklogin() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    if (token != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => const DashboardPage())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserReposity>();

    return Scaffold(
      body: SingleChildScrollView(
        child:
          SizedBox(
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
                        "Login",
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
                    decoration: const InputDecoration(
                      label: Text("Username")
                  ),),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text("Password")
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(onPressed: () => 
                      controller.login(usernameController.text, passwordController.text)
                    , child: const Text("Login")),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account ?"),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegisterPage()));
                        }, 
                        child: const Text("Create Account", style: TextStyle(color: Colors.indigo))
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
      ),
    );

  }
}