import 'package:flutter/material.dart';
import 'package:flutter_application/pages/login.dart';
import 'package:flutter_application/pages/update_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({ Key? key }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String token = "";

  void getCred() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token")!;
    });
  }

  @override
  void initState() {
    getCred();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              ListTile(
                title: const Text("Update user information"),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateUserPage(token: token)));
                },
              ),
              ListTile(
                title: const Text("Logout"),
                onTap: () async{
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.clear();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}