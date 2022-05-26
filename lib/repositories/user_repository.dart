import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState {idle, loading, success, invalid, error}

class UserReposity extends ChangeNotifier{

    var state = AuthState.idle;
    
    void login(String username, String password) async {
      state = AuthState.loading;
      
      if (username.isNotEmpty && password.isNotEmpty){
        var response = await http.post(Uri.parse("http://10.0.0.137:8000/login"), body:{
          "username": username,
          "password": password
        });

        if (response.statusCode == 200){
          final body = jsonDecode(response.body);
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences.setString("token", body["token"]);
          await sharedPreferences.setInt("user_id", body["user_id"]);
          await sharedPreferences.setString("is_instructor", body["is_instructor"].toString());
          state = AuthState.success;

        } else{
          state = AuthState.invalid;
        }
      } else{
        state = AuthState.error;
      }
      notifyListeners();
  }

  void register(String username, String email, String password, String isInstructor) async {
    state = AuthState.loading;

    var response =
      await http.post(Uri.parse("http://10.0.0.137:8000/register"), body: jsonEncode(
        {
      "username": username,
      "email": email,
      "password": password,
      "is_instructor": isInstructor == "Instrutor" ? true : false
      }), headers: {"content-type": "application/json"});

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      state = AuthState.success;

      await sharedPreferences.setString("token", body["token"]);
      await sharedPreferences.setInt("user_id", body["user_id"]);
      await sharedPreferences.setString("is_instructor", body["is_instructor"].toString());

    } else {
      state = AuthState.invalid;
    }

    notifyListeners();
  }

  Future update(String username, String email, String token) async {
    state = AuthState.loading; 

    var response = await http.patch(Uri.parse("http://10.0.0.137:8000/user/update"), body: jsonEncode({
        "username": username,
        "email": email
    }), headers: {"content-type": "application/json", "Authorization": "Token $token"});

    if (response.statusCode == 200){
      state = AuthState.success;
    } else{
      state = AuthState.error;
    }

    notifyListeners();
  }
}