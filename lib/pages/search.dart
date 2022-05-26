import 'package:flutter/material.dart';
import 'package:flutter_application/components/course_card.dart';
import 'package:flutter_application/models/course_model.dart';
import 'package:flutter_application/repositories/course_repository.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String ?query;
  CourseRepository? controller;

  @override
  void initState() {
    controller = context.read<CourseRepository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                onSubmitted: (value) {
                  setState(() {
                    query = value;
                  });
                }
              ),
              FutureBuilder<List<Course>>(
                future: controller!.getCourses(query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData){
                    List<Course> courses = snapshot.data ?? [];
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: courses.length,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                          margin: const EdgeInsets.all(20.0),
                          child: PostCard(course: courses[index])
                        );
                      }
                    );
                  }

                  return const Text("Error");

                }
              )
            ]
        ) 
      )
      ));
  }
}