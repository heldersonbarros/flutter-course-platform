import 'package:flutter/material.dart';
import 'package:flutter_application/pages/account_page.dart';
import 'package:flutter_application/pages/add_course.dart';
import 'package:flutter_application/pages/home.dart';
import 'package:flutter_application/pages/my_courses.dart';
import 'package:flutter_application/pages/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({ Key? key }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int index = 0;
  String? is_istructor;

  void getCred() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      is_istructor = sharedPreferences.getString("is_instructor");
    });

  }

  @override
  void initState() {
    getCred();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        IndexedStack(
          index: index,
          children: [
            const HomePage(),
            const SearchPage(),
            if (is_istructor == "true") const AddCoursePage(),
            const MyCoursesPage(),
            const AccountPage()
        ],),
        
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search"
          ),
          if (is_istructor == "true") const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Course",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: "My courses"
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account"
          ),
        ]),
    );
  }
}