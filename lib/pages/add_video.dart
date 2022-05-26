import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:async/async.dart';

class AddVideoPage extends StatefulWidget {
  final token;
  final course;
  const AddVideoPage({ Key? key, required this.token, required this.course}) : super(key: key);

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  TextEditingController titleController = TextEditingController();
  XFile? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar vídeo aula"),
      ),
      body: SingleChildScrollView(
        child: 
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: titleController,
                  ),
                  ListTile(
                    leading: const Icon(Icons.video_file),
                    title: const Text("Selecionar video"),
                    onTap: selecionarvideo,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: (){
                        createVideoClass();
                      },
                      child: const Text("Adicionar video aula"),
                      ),
                  )  
                ],
              ),
              )
          )
        ),
    );
  }

  selecionarvideo() async{
    final ImagePicker videoPicker = ImagePicker();
    try{
      file = await videoPicker.pickVideo(source: ImageSource.gallery);
    } catch (e){
      print(e);
    }
  }

  void createVideoClass() async{
      var stream = http.ByteStream(DelegatingStream.typed(file!.openRead()));
      var length = await file!.length();
      var uri = Uri.parse("http://10.0.0.137:8000/course/add_video");
      var request = http.MultipartRequest("POST", uri);

      var multipartFile = http.MultipartFile('video', stream, length,
          filename: basename(file!.path));

      request.files.add(multipartFile);
      request.fields["title"] = titleController.text;

      request.fields["course"] = widget.course.id.toString();
      request.headers["Authorization"] = "Token ${widget.token}";

      var response = await request.send();

      if (response.statusCode == 201) {
      }
  }
}