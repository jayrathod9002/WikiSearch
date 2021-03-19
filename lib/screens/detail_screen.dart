import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wiki_search/model/wiki_pages.dart';
import 'package:wiki_search/webservice/myConnectionStatus.dart';
import 'package:wiki_search/webservice/webapi.dart';

class DetailScreen extends StatefulWidget {
  String title;
  String pageId;
  Pages pages;

  DetailScreen(this.pages, {Key key});

  @override
  State<StatefulWidget> createState() {
    return DetailState();
  }
}

class DetailState extends State<DetailScreen> {
  var content = "";
  bool isLoading = true;

  @override
  void initState() {
    MyConnectionStatus().check().then((intenet) async {
      if (intenet != null && intenet) {
        WebApi()
            .getDetailApi(widget.pages.title.replaceAll(" ", "%20"))
            .then((value) {
          if (value != null) {
            var dict = jsonDecode(value.body);
            setState(() {
              content = dict['query']['pages'][widget.pages.pageid.toString()]
                  ['extract'];
              isLoading = false;
            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.orange,
        automaticallyImplyLeading: true,
        title: Text(widget.pages.title),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Html(
                data: content,
              ),
            ),
    );
  }
}
