import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/pages/add_video.dart';
import 'package:flutter_application/pages/update_course.dart';
import 'package:flutter_application/pages/video_play.dart';
import 'package:flutter_application/repositories/course_repository.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/course_model.dart';


class CourseDetail extends StatefulWidget {
  final course;
  const CourseDetail({ Key? key, required this.course }) : super(key: key);

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  String token = "";
  int? user_id;
  Future<Course>? courseDetailFuture;
  bool is_joined = false;
  CourseRepository? controller;

  @override
  void initState() {
    getCred();
    controller = context.read<CourseRepository>();
    controller!.addListener(() {
      String message = "";
      if (controller!.state == CourseState.deleted){
        Navigator.pop(context);
      } else{
        if (controller!.state == CourseState.joined){
          message = "Successfully joined course";
          is_joined = true;
        } else if (controller!.state == CourseState.left){
          message = "Successfully leave course";
          is_joined = false;
        } else if (controller!.state == CourseState.error){
          message = "Something went wrong, please try again, or restart the app";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }

    });
    super.initState();
  }

  void getCred() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token")!;
      user_id = sharedPreferences.getInt("user_id");
    });
    controller = context.read<CourseRepository>();
    courseDetailFuture = controller!.courseDetail(widget.course.id, token);
  }
  @override
  Widget build(BuildContext context) {
    controller = context.watch<CourseRepository>();

    return FutureBuilder<Course>(
      future: courseDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData){
          Course? courseRetrieved = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(courseRetrieved?.name ?? ""),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: 
                          Row(
                            children: [
                            Expanded(
                              child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage("assets/images/image_example.jpg"))),
                            )),
                            ],
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              courseRetrieved?.name ?? "",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            if (user_id == courseRetrieved!.instructor!.id) DropdownButtonHideUnderline(child: DropdownButton<String>(
                              icon: const Icon(Icons.more_vert),
                              items: const [
                                DropdownMenuItem(child: Text("Update"), value: "update"),
                                DropdownMenuItem(child: Text("Remove"), value: "remove")
                              ], 
                              onChanged: (value){
                                if (value=="update"){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateCourse(course: courseRetrieved, token: token))).then((value) {
                                    setState(() {
                                      courseDetailFuture = controller!.courseDetail(widget.course.id, token);
                                    });
                                  });
                                } else if (value=="remove"){
                                  _showDialog(context);
                                }
                              })
                            ) 
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              courseRetrieved.description ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 15,
                                color: Colors.grey
                                ),
                            )
                          ]),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                          onPressed: (() async {
                            controller!.joinCourse(courseRetrieved.id, token);
                          }), 
                          child: Text(is_joined ? "Leave": "Join", style: TextStyle(color: is_joined ? Colors.black : Colors.white)),
                          style: ElevatedButton.styleFrom(
                            primary: is_joined ? Colors.white : Colors.indigo,
                            side: is_joined ? const BorderSide(color: Colors.indigo, width: 2.0) : null
                          ),
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                          itemCount: courseRetrieved.videoclassList?.length ?? 0,
                          itemBuilder: (BuildContext context, index){
                            return ListTile(
                                title: Text(courseRetrieved.videoclassList![index].title),
                                leading: const Icon(Icons.video_library),
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoPage(video: courseRetrieved.videoclassList![index])))
                              );
                            },
                          ),
                        )            
                    ],),
                  )) 
              ),
              floatingActionButton: 
                Visibility(
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddVideoPage(token: token, course: courseRetrieved,)));
                      },
                      label: const Text("Adicionar aula"),
                      icon: const Icon(Icons.add)
                    ),
                  visible: user_id == courseRetrieved.instructor!.id,
              ),
          );
          }
          return const Text("ERROR");
        }
      );
  }

  Future<void> _showDialog(context) {
    return showDialog<void>(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Delete course"),
        content: const Text("Are you sure you want to delete this course?"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("No")),
          TextButton(onPressed: (){
            Navigator.pop(context);
            controller!.courseDelete(widget.course.id, token);
          }, child:  const Text("Yes"))
        ]);
    });
  }
}