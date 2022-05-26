import 'package:flutter/material.dart';
import 'package:flutter_application/repositories/user_repository.dart';
import 'package:provider/provider.dart';

class UpdateUserPage extends StatefulWidget {
  final String? token;
  const UpdateUserPage({ Key? key, required this.token }) : super(key: key);

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();

  @override
  void initState() {
    final controller = context.read<UserReposity>();
    controller.addListener(() {
      if (controller.state == AuthState.success){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update successfully")));
      } else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong, please try again, or restart the app")));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserReposity>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Update user"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    label: Text("Username")
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    label: Text("Email")
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(onPressed: (){
                    controller.update(usernameController.text, emailController.text, widget.token!);
                  }, child: const Text("Update")),
                )
              ]),
            ),
            
          )
          )

        );
  }
}