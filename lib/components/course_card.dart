import 'package:flutter/material.dart';
import 'package:flutter_application/models/course_model.dart';

class PostCard extends StatefulWidget {
  final Course course;
  const PostCard({Key? key, required this.course}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/image_example.jpg"))),
                  )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.course.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                widget.course.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                              ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(children: [
                            const Icon(Icons.groups),
                            Text(widget.course.studentsCount.toString())
                          ],)
                        ],
                      )
                      ),
                ],
              )),
        ],
      ),
    );
  }
}
