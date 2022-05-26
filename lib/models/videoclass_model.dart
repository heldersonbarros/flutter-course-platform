class VideoClass{
  int id;
  String title;
  String video;

  VideoClass({required this.id, required this.title, required this.video});

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "title": title,
      "video": video
    };
  }

  factory VideoClass.fromMap(Map<String, dynamic> map) {
    return VideoClass(
      id: map["id"],
      title: map["title"],
      video: map["video"],
      );
  }
}