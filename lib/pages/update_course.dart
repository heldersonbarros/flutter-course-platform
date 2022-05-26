import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateCourse extends StatefulWidget {
  final course;
  final token;
  const UpdateCourse({ Key? key, required this.course, required this.token}) : super(key: key);

  @override
  State<UpdateCourse> createState() => _UpdateCourseState();
}

class _UpdateCourseState extends State<UpdateCourse> {

  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  @override

  void initState(){
    super.initState();
    nameController.text = widget.course.name;
    descriptionController.text = widget.course.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar curso"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(label: Text("Name")),
                ),
                TextField(
                  maxLines: 5,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  maxLength: 180,
                  controller: descriptionController,
                  decoration: const InputDecoration(label: Text("Description")),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(onPressed: (() {
                  updateCourse();
                }), child: const Text("Update course"))
            ],),
          )
          ),  
      ),
    );
  }

  void updateCourse() async{
    var response =
      await http.patch(Uri.parse("http://10.0.0.137:8000/course/${widget.course.id}/update"), body: jsonEncode(
        {
      "name": nameController.text,
      "description": descriptionController.text,
      }), headers: {"content-type": "application/json", "Authorization": "Token ${widget.token}"});

    if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Successfully updated course")));
        Navigator.pop(context, (){setState(() {
          
        });});

    }
        else{
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Input")));
    }
  }
}