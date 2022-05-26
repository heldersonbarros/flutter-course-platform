class Instructor {
  int? id;
  String? username;

  Instructor({this.id, this.username});

  Instructor.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    return data;
  }
}