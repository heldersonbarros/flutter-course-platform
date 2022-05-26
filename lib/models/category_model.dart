import 'course_model.dart';

class CategoryModel {
  String? name;
  List<Course>? courses;

  CategoryModel({this.name, this.courses});

  CategoryModel.fromMap(Map<String, dynamic> json) {
    name = json['name'];
    if (json['courses'] != null) {
      courses = <Course>[];
      json['courses'].forEach((v) {
        courses!.add(Course.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    if (courses != null) {
      data['courses'] = courses!.map((v) => v.toMap()).toList();
    }
    return data;
  }
}