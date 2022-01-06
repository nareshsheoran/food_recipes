import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/model.dart';
import 'package:food_recipe/recipe_view.dart';
import 'package:food_recipe/search.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<RecipeModel> recipeList = <RecipeModel>[];
  List recipeCatList = [
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    }
  ];

  getRecipes(String query) async {
    String url =
        'https://api.edamam.com/search?q=$query&app_id=d0b6bcf6&app_key=7cb71e800f3e042ebe0f0241e3ab4a57';
    Response response = await http.get(Uri.parse(url));

    print("Status Code ${response.statusCode}");
    //print("Response Body ${response.body}");

    Map data = jsonDecode(response.body);
    // print(data);
    //log(data.toString());
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading = false;
        });
        log(recipeList.toString());
      });
    });

    recipeList.forEach((recipe) {
      // print(recipe.appLabel);
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipes("Banana");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff213A50),
                  Color(0xff071938),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    //Search Container
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if ((searchController.text).replaceAll('', '') ==
                                '') {
                              print('Blank Search');
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Search(searchController.text)));
                            }
                          },
                          child: Container(
                            child: const Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              if (value == '') {
                                print("Please Enter Text To Search");
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Search(searchController.text)));
                              }
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's Search To Cook!"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Text Container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'What Do You Want To Cook Today?',
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's Cook Something New!",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                //ListView Container
                Container(
                  child: isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child: const Center(
                                  child: CircularProgressIndicator())),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recipeList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeView(
                                            recipeList[index].appUrl)));
                              },
                              child: Card(
                                margin: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        recipeList[index].appImgUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 250,
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            color: Colors.black26),
                                        child: Text(
                                          recipeList[index].appLabel,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      width: 100,
                                      height: 40,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            )),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.local_fire_department,
                                                size: 15,
                                              ),
                                              Text(recipeList[index]
                                                  .appCalories
                                                  .toString()
                                                  .substring(0, 6)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                //Last Container
                Container(
                  height: 100,
                  child: ListView.builder(
                    itemCount: recipeCatList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Search(
                                    recipeCatList[index]["heading"],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                      recipeCatList[index]["imgUrl"],
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 250,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black26),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            recipeCatList[index]["heading"],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
