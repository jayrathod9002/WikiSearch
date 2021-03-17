import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wiki_search/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:wiki_search/model/wiki_pages.dart';
import 'package:wiki_search/webservice/webapi.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  bool isLoading = true;
  List<PostModel> postModels;

  final _controller = ScrollController();

  @override
  void initState() {
    fetchModels();

    WebApi().getList().then((value) {
      print("res >" + value.toString());
      final wikiObj = WikiPages.fromJson(jsonDecode(value.toString()));
      print("qry =>" + wikiObj.query.toString());
    });

    super.initState();
  }

  Future<List<PostModel>> fetchModels() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        postModels = jsonResponse
            .map<PostModel>((json) => PostModel.fromJson(json))
            .toList();
        isLoading = false;
      });
      print('success 200');
      return jsonResponse.map((e) => PostModel.fromJson(e)).toList();
    } else {
      print('else failed');
      throw Exception('Failed to load post ');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Wiki Search'),
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            width: width,
            margin: EdgeInsets.all(12.0),
            height: 80,
            child: Center(
              child: Row(
                children: [
                  Container(
                    width: width * 0.90,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.search,
                            ),
                            labelText: 'Search'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: Container(
                    height: height,
                    width: width,
                    child: listView(context, postModels, _controller),
                  ),
                ),
        ],
      )),
    );
  }

  Widget listView(BuildContext context, List<PostModel> postModel,
      ScrollController controllerr) {
    List<PostModel> post = postModel;
    print("postList " + post.length.toString() + " list");

    return ListView.builder(
        controller: controllerr,
        itemCount: post.length,
        itemBuilder: (BuildContext context, int index) {
          PostModel model = post[index];
          return cardViewWidget(context, model);
        });
  }

  Widget cardViewWidget(BuildContext context, PostModel postModel) {
    return Container(
      margin: EdgeInsets.only(top: 1, bottom: 0, left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      height: 90.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              width: 110,
              color: Colors.orange,
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Title',
                          style: TextStyle(fontSize: 20),
                        )),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Descriptions',
                          style: TextStyle(fontSize: 16),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
