import 'package:flutter/material.dart';
import 'package:flutter_application/components/course_card.dart';
import 'package:flutter_application/models/category_model.dart';
import 'package:flutter_application/models/course_model.dart';
import 'package:flutter_application/pages/course_detail.dart';
import 'package:flutter_application/repositories/course_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomaPageState();
}

class _HomaPageState extends State<HomePage> {
  String token = "";
  PageController? pageController;
  Future <List<CategoryModel>>? getCategoriesFuture;
  late CourseRepository controller;

  @override
  void initState() {
    controller = context.read<CourseRepository>();
    setState(() {
      getCred();
    });

    pageController = PageController(viewportFraction: 0.8);
    getCategoriesFuture = controller.getCategories();
    super.initState();
  }

  void getCred() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token")!;
    });
  }

  // refresh não está funcionando mais?

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child:
          SizedBox(
            child: RefreshIndicator(
              onRefresh: () => getCategoriesFuture!,
              child: FutureBuilder<List<CategoryModel>>(
                future: getCategoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData){
                    List<CategoryModel> categories = snapshot.data ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, index) {
                        CategoryModel category = categories[index];
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category.name!, style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0
                              )),
                              const Text("See more")
                            ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: PageView.builder(
                                itemCount: category.courses!.length,
                                controller: pageController,
                                itemBuilder: ((context, index) {
                                  Course course = category.courses![index];
                                  return GestureDetector(
                                    child: Card(
                                    margin: const EdgeInsets.all(20.0),
                                    child: PostCard(course: course)
                                  ),
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> CourseDetail(course: course)))
                                  );
                
                                }),
                              ),
                          ),
                        ],);
                      },
                    );
                }
                return const Text("Error");
                }),
            ),
          ),
        ),
      ],
    );
  }
}
