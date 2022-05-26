import 'package:flutter_application/models/videoclass_model.dart';

import 'instructor_model.dart';

class Course{
  int? id;
  String? name;
  String? createdAt;
  String? description;
  int? studentsCount;
  bool? is_joined;
  Instructor? instructor;
  List<VideoClass>? videoclassList;

  Course({required this.id, required this.name, required this.createdAt, required this.description, required this.studentsCount, required this.is_joined});

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "name": name,
      "created_at": createdAt,
      "description": description,
      "students_count": studentsCount,
      "is_joined": is_joined
    };
  }

  Course.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    instructor = json['instructor'] != null
        ? Instructor.fromMap(json['instructor'])
        : null;
    createdAt = json['created_at'];
    description = json['description'];
    studentsCount = json['students_count'];
    is_joined = json['is_joined'];
    if (json['videoclass_list'] != null) {
      videoclassList = <VideoClass>[];
      json['videoclass_list'].forEach((v) {
        videoclassList!.add(VideoClass.fromMap(v));
      });
    }
  }
}