import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wiki_search/model/wiki_pages.dart';
import 'package:wiki_search/screens/detail_screen.dart';
import 'package:wiki_search/webservice/myConnectionStatus.dart';
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
  String searchText = "India";

  int pageNum = 1;
  bool isPageLoading = false;
  bool isMainLoding = false;

  final _scrollController = ScrollController();
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    pages = new List<Pages>();
    searchPages = new List<Pages>();

    MyConnectionStatus().check().then((intenet) async {
      if (intenet != null && intenet) {
        fetchPages(pageNum, searchText);
        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            pageNum = pageNum + 1;
            fetchPages(pageNum, searchText);
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: "Network not available",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });

    super.initState();
  }

  fetchPages(int page, String text) async {
    if (pageNum == 1) {
      isMainLoding = true;
    }
    WebApi().getList(page, text).then((value) {
      final wikiObj = WikiPages.fromJson(jsonDecode(value.body.toString()));
      setState(() {
        pages.addAll(wikiObj.query.pages);
        isLoading = false;
      });
    });
  }

  onSearchTextChanged(String text) async {
    pages.clear();
    fetchPages(1, text);

    setState(() {
      searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
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
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
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

    return ListView.builder(
        controller: controllerr,
        itemCount: post.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          Pages model = post[index];
          String thumb = model.thumbnail == null
              ? "http://via.placeholder.com/640x360"
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
