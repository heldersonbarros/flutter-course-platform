import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import '../models/category_model.dart';
import 'package:path/path.dart';
import '../models/course_model.dart';

enum CourseState {idle, loading, success, invalid, error, left, joined, deleted}

class CourseRepository extends ChangeNotifier{

  var state = CourseState.idle;

  Future <List<CategoryModel>> getCategories() async {
    List<CategoryModel> categories = [];
    var response = await http.get(Uri.parse("http://10.0.0.137:8000/"));
    var data = jsonDecode(response.body);
    data.forEach((element) {
        CategoryModel category = CategoryModel.fromMap(element);
        categories.add(category);
    });

    return categories;
  }

  Future<List<Course>> getCourses(query) async {
    List<Course> coursesList = [];
    var response = await http.get(Uri.parse("http://10.0.0.137:8000/explore?q=$query"));
    var data = jsonDecode(response.body);
    data.forEach((element) {
      coursesList.add(Course.fromMap(element));
    });

    return coursesList;
  }

  void createCourse(String name, String description, XFile image, String token) async{
    state = CourseState.loading;

    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse("http://10.0.0.137:8000/course/create");
    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile('cover', stream, length, filename: basename(image.path));
    request.files.add(multipartFile);

    request.fields["name"] = name;
    request.fields["description"] = description;
    request.headers["Authorization"] = "Token $token";

    var response = await request.send();

    if (response.statusCode == 201) {
        state = CourseState.success;
    } else{
        state = CourseState.invalid;
    }

      notifyListeners();
    }

  Future<List<Course>> getMyCourses(String? token) async {
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

  Future<Course> courseDetail(int courseId, String token) async{
    var response = await http.get(Uri.parse("http://10.0.0.137:8000/course/$courseId"),
                    headers: {"content-type": "application/json", "Authorization": "Token $token"});

    var data = jsonDecode(response.body);
    Course courseRetrieved = Course.fromMap(data);

    return courseRetrieved;

  }

  Future<void> courseDelete(int courseId, String token) async{
    state = CourseState.loading;
    var response = await http.delete(Uri.parse("http://10.0.0.137:8000/course/$courseId/delete"),
                    headers: {"content-type": "application/json", "Authorization": "Token $token"});


    if (response.statusCode == 204){
      state = CourseState.deleted;
    } else{
      state = CourseState.error;
    }

    notifyListeners();
  }

  void joinCourse(int? courseId, String token) async{
    state = CourseState.loading;

    var response =
      await http.post(Uri.parse("http://10.0.0.137:8000/course/$courseId/join"), headers: {"content-type": "application/json", "Authorization": "Token $token"});
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json["joined"] == true){
        state = CourseState.joined;
      } else{
        state = CourseState.left;
      }
    } else{
      state = CourseState.error;
    }

    notifyListeners();
  }
}