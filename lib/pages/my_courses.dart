import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/components/course_card.dart';
import 'package:flutter_application/models/course_model.dart';
import 'package:flutter_application/repositories/course_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({ Key? key }) : super(key: key);

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  String? token;
  Future<List<Course>>? getMyCoursesFuture;
  CourseRepository? controller;
  
  @override
  void initState() {
    controller = context.read<CourseRepository>();
    getCred();
    super.initState();
  }
  
  Future getCred() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token")!;
    });
    getMyCoursesFuture = controller!.getMyCourses(token);
  }

  Future<List<Course>> getCourses() async {
    List<Course> courses = [];
    if (token != null){
      var response = await http.get(Uri.parse("http://10.0.0.137:8000/my_courses"),
        headers: {"Authorization": "Token $token"});
    
    var data = jsonDecode(response.body);
    data.forEach((element) {
        courses.add(Course.fromMap(element));
    });
    }
    return courses;
  }
  
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CourseRepository>();
    
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: RefreshIndicator(
          onRefresh: () => controller.getMyCourses(token!),
          child: FutureBuilder<List<Course>>(
            future: getMyCoursesFuture,
            builder: (context, snapshot) {
              List<Course> courses = snapshot.data ?? [];
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              } 

              if (snapshot.hasData){
                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      margin: const EdgeInsets.all(20.0),
                      child: PostCard(course: courses[index]),
                    );
                  },
                );
              }

              return const Center(child: Text("Nothing to show here"));
            }
          ),
        ),
      ),
      Center(child: Column(children: []))
    ]);
  }
}