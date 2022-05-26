import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/repositories/course_repository.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({ Key? key }) : super(key: key);

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  String token = "";
  XFile? file;

  @override
  void initState() {
    final controller = context.read<CourseRepository>();
    controller.addListener(() {
      if (controller.state == CourseState.success){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Curso criado com sucesso")));
        nameController.clear();
        descriptionController.clear();
    } else if (controller.state == CourseState.invalid){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Input")));
    }
    });

    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CourseRepository>();


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
                ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text("Pick a image for cover"),
                    onTap: pickImage,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(onPressed: (() => 
                    controller.createCourse(nameController.text, descriptionController.text, file!, token)), 
                    child: const Text("Add course")),
                )
            ],),
          )
          ),  
      ),
    );
  }
  
  pickImage() async{
    final ImagePicker videoPicker = ImagePicker();
    try{
      file = await videoPicker.pickImage(source: ImageSource.gallery);
    } catch (e){
      print(e);
    }
  }
}