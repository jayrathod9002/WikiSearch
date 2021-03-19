import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wiki_search/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:wiki_search/model/wiki_pages.dart';
import 'package:wiki_search/screens/detail_screen.dart';
import 'package:wiki_search/webservice/webapi.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  bool isLoading = true;
  List<Pages> pages;
  List<Pages> searchPages;
  String searchText = "Test";

  int pageNum = 1;
  bool isPageLoading = false;
  bool isMainLoding = false;

  final _scrollController = ScrollController();
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    pages = new List<Pages>();
    searchPages = new List<Pages>();
    //fetchModels();

    fetchPages(pageNum, searchText);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        pageNum = pageNum + 1;
        fetchPages(pageNum, searchText);
      }
    });

    super.initState();
  }

  fetchPages(int page, String text) async {
    if (pageNum == 1) {
      isMainLoding = true;
    }
    WebApi().getList(page, text).then((value) {
      print("res >" + value.toString());
      final wikiObj = WikiPages.fromJson(jsonDecode(value.body.toString()));
      print("qry =>" + wikiObj.query.pages.length.toString());
      setState(() {
        pages.clear();
        pages.addAll(wikiObj.query.pages);
        isLoading = false;
        pageNum++;
      });
    });
  }

  onSearchTextChanged(String text) async {
    fetchPages(1, text);

    setState(() {
      searchText = text;
    });
    /*searchPages.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    pages.forEach((page) {
      if (page.title.contains(text)) searchPages.add(page);
    });

    setState(() {});*/
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.orange,
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
                      child: TextField(
                        controller: controller,
                        onChanged: onSearchTextChanged,
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
                    child: listView(context, pages, _scrollController),
                  ),
                ),
        ],
      )),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget listView(
      BuildContext context, List<Pages> pages, ScrollController controllerr) {
    List<Pages> post = pages;
    print("postList " + post.length.toString() + " list");

    return ListView.builder(
        controller: controllerr,
        itemCount: post.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          Pages model = post[index];
          String thumb = model.thumbnail == null
              ? "http://via.placeholder.com/640x360" //https://picsum.photos/250?image=9
              : model.thumbnail.source;
          String desc =
              model.terms == null ? "" : model.terms.description.first;
          return cardViewWidget(context, model, thumb, desc);
        });
  }

  Widget cardViewWidget(
      BuildContext context, Pages pagesModel, String thumb, String desc) {
    return GestureDetector(
      onTap: () {
        print('page id ' + pagesModel.pageid.toString());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailScreen(pagesModel)));
      },
      child: Container(
        margin: EdgeInsets.only(top: 1, bottom: 0, left: 10, right: 10),
        width: MediaQuery.of(context).size.width,
        height: 90.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                width: 110,
                child: Image.network(
                  thumb,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
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
                            pagesModel.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )),
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
